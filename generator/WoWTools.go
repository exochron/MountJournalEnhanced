package main

import (
	"bytes"
	"encoding/csv"
	"io/ioutil"
	"log"
	"net/http"
	"regexp"
	"strconv"
	"strings"
)

type mount struct {
	ID              int
	SpellID         int
	Name            string
	Icon            string
	ItemIsTradeable bool
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

func getCSV(table string, build string) []map[string]string {
	url := "dbc/api/export/?name=" + strings.ToLower(table) + "&useHotfixes=true&build=" + build
	data := request(url)
	csvReader := csv.NewReader(bytes.NewReader(data))
	records, err := csvReader.ReadAll()

	if err != nil {
		log.Fatal(err)
	}

	header := records[0]

	results := make([]map[string]string, len(records[1:]))
	for rowNumber, row := range records[1:] {

		mapped := map[string]string{}
		for columnNumber, column := range header {
			mapped[column] = row[columnNumber]
		}

		results[rowNumber] = mapped
	}

	return results
}

func loadTradeableItems(build string) map[int]bool {
	itemSparseCsv := getCSV("ItemSparse", build)

	items := map[int]bool{}
	for _, record := range itemSparseCsv {
		if record["Bonding"] == "0" {
			itemId, _ := strconv.Atoi(record["ID"])
			items[itemId] = true
		}
	}

	return items
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

	mountCsv := getCSV("Mount", build)

	mounts := map[int]mount{}
	for _, record := range mountCsv {
		id, _ := strconv.Atoi(record["ID"])
		spellId, _ := strconv.Atoi(record["SourceSpellID"])
		mounts[spellId] = mount{id, spellId, record["Name_lang"], "", false}
	}

	tradeableItems := loadTradeableItems(build)

	itemEffectsCsv := getCSV("ItemEffect", build)
	for _, record := range itemEffectsCsv {
		// LegacySlotIndex == 1 and TriggerType == 6(Learn Spell)
		if record["LegacySlotIndex"] == "1" && record["TriggerType"] == "6" {
			spellId, _ := strconv.Atoi(record["SpellID"])
			if mount, ok := mounts[spellId]; ok {
				itemId, _ := strconv.Atoi(record["ParentItemID"])
				if _, ok := tradeableItems[itemId]; ok {
					mount.ItemIsTradeable = true
					mounts[spellId] = mount
				}
			}
		}
	}

	iconFiles := loadIconFiles()
	spellMiscCsv := getCSV("SpellMisc", build)
	for _, record := range spellMiscCsv {
		spellId, _ := strconv.Atoi(record["SpellID"])
		if mount, ok := mounts[spellId]; ok {
			fileId, _ := strconv.Atoi(record["SpellIconFileDataID"])
			mount.Icon = iconFiles[fileId]
			mounts[spellId] = mount
		}
	}

	return mounts
}
