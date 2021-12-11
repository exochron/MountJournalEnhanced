package main

import (
	"bytes"
	"encoding/csv"
	"io/ioutil"
	"log"
	"mje_generator/condition"
	"net/http"
	"regexp"
	"strconv"
	"strings"
)

type mount struct {
	ID               int
	SpellID          int
	Name             string
	Icon             string
	ItemIsTradeable  bool
	PlayerConditions [][]condition.Condition
}

func fetchBuild(branch string) string {
	html := string(request(""))

	reg := regexp.MustCompile(`(?Ui)<td>` + branch + `</td>\s+<td>(.*)</td>`)
	matches := reg.FindStringSubmatch(html)
	if len(matches) > 0 {
		return matches[1]
	}

	log.Fatalln("unknown branch:", branch)
	return ""
}

func request(url string) []byte {
	resp, err := http.Get("https://wow.tools/" + url)
	if err != nil {
		print(err)
	}
	defer resp.Body.Close()

	payload, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		log.Fatal(err)
	}

	return payload
}

func getCSV(table string, build string) map[int]map[string]string {
	url := "dbc/api/export/?name=" + strings.ToLower(table) + "&useHotfixes=true&build=" + build
	data := request(url)
	csvReader := csv.NewReader(bytes.NewReader(data))
	records, err := csvReader.ReadAll()

	if err != nil {
		log.Fatal(err)
	}

	header := records[0]

	results := map[int]map[string]string{}

	for _, row := range records[1:] {

		mapped := map[string]string{}
		for columnNumber, column := range header {
			mapped[column] = row[columnNumber]
		}

		id, _ := strconv.Atoi(mapped["ID"])
		results[id] = mapped
	}

	return results
}

func loadTradeableItems(build string) map[int]int {
	itemSparseCsv := getCSV("ItemSparse", build)

	result := map[int]int{}
	items := map[int]struct{}{}
	for itemId, record := range itemSparseCsv {
		if record["Bonding"] == "0" {
			items[itemId] = struct{}{}
		}
	}

	itemEffects := getCSV("ItemEffect", build)
	itemXEffectsCsv := getCSV("ItemXItemEffect", build)
	for _, record := range itemXEffectsCsv {
		effectId, _ := strconv.Atoi(record["ItemEffectID"])
		itemId, _ := strconv.Atoi(record["ItemID"])
		if _, ok := items[itemId]; ok {
			if effectData, ok := itemEffects[effectId]; ok && effectData["TriggerType"] == "6" {
				spellId, _ := strconv.Atoi(effectData["SpellID"])
				result[itemId] = spellId
			}
		}
	}

	return result
}

func loadIconFiles() map[int]string {
	data := request("casc/listfile/download/csv")
	csvReader := csv.NewReader(bytes.NewReader(data))
	csvReader.Comma = ';'
	records, err := csvReader.ReadAll()

	if err != nil {
		log.Fatal(err)
	}

	regex := regexp.MustCompile(`interface/icons/(.*)\.blp`)

	result := map[int]string{}

	for _, record := range records {
		find := regex.FindStringSubmatch(record[1])
		if find != nil {
			fileId, _ := strconv.Atoi(record[0])
			result[fileId] = find[1]
		}
	}

	return result
}

func LoadFromWoWTools(branch string) map[int]mount {

	build := fetchBuild(branch)

	playerConditions := getCSV("PlayerCondition", build)

	mountCsv := getCSV("Mount", build)
	mounts := map[int]mount{}
	spellToMount := map[int]int{}
	for _, record := range mountCsv {
		id, _ := strconv.Atoi(record["ID"])
		spellId, _ := strconv.Atoi(record["SourceSpellID"])
		playerConditionId, _ := strconv.Atoi(record["PlayerConditionID"])
		var mountConditions [][]condition.Condition
		if playerCondition, ok := playerConditions[playerConditionId]; ok {
			mountConditions = condition.NewConditions(playerCondition)
		}

		mounts[id] = mount{
			id,
			spellId,
			record["Name_lang"],
			"",
			false,
			mountConditions,
		}
		spellToMount[spellId] = id
	}

	tradeableItems := loadTradeableItems(build)
	for _, spellId := range tradeableItems {
		if id, ok := spellToMount[spellId]; ok {
			mount := mounts[id]
			mount.ItemIsTradeable = true
			mounts[id] = mount
		}
	}

	iconFiles := loadIconFiles()
	spellMiscCsv := getCSV("SpellMisc", build)
	for _, record := range spellMiscCsv {
		spellId, _ := strconv.Atoi(record["SpellID"])
		if id, ok := spellToMount[spellId]; ok {
			fileId, _ := strconv.Atoi(record["SpellIconFileDataID"])
			mount := mounts[id]
			mount.Icon = iconFiles[fileId]
			mounts[id] = mount
		}
	}

	return mounts
}
