package main

import (
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
)

func (m mount) WriteToFile(file *os.File) {
	file.WriteString("[" + strconv.Itoa(m.ID) + "] = true, -- " + m.Name + "\n")
}

func prepareLuaDB(filename string, varname string) *os.File {

	file, err := os.OpenFile(filename, os.O_TRUNC|os.O_WRONLY|os.O_CREATE, 0755)

	if err != nil {
		log.Fatal(err)
	}

	file.WriteString("local _, ADDON = ...\n\n")
	file.WriteString("ADDON.DB." + varname + " = {\n")

	return file
}

func getOrderedKeys(list map[int]*mount) []int {
	keys := make([]int, 0, len(list))
	for k := range list {
		keys = append(keys, k)
	}
	sort.Ints(keys)

	return keys
}

func ExportTradeable(mounts map[int]*mount) {
	file := prepareLuaDB("tradable.db.lua", "Tradable")

	keys := getOrderedKeys(mounts)

	for _, k := range keys {
		mount := mounts[k]
		if mount.ItemIsTradeable == true {
			mount.WriteToFile(file)
		}
	}

	file.WriteString("}")

	defer file.Close()
}

func exportFamilyCategories(config []familyConfig, file *os.File) {

	for _, c := range config {
		file.WriteString("[\"" + c.Name + "\"] = {\n")

		if len(c.Mounts) > 0 {
			sort.Slice(c.Mounts, func(i, j int) bool {
				return c.Mounts[i].SpellID < c.Mounts[j].SpellID
			})

			for _, mount := range c.Mounts {
				mount.WriteToFile(file)
			}
		} else {
			exportFamilyCategories(c.SubFamily, file)
		}

		file.WriteString("},\n")
	}
}

func ExportFamilies(config []familyConfig) {
	file := prepareLuaDB("families.db.lua", "Family")

	exportFamilyCategories(config, file)

	file.WriteString("}")

	defer file.Close()
}

func ExportConditions(mounts map[int]*mount) {
	file := prepareLuaDB("restrictions.db.lua", "Restrictions")

	keys := getOrderedKeys(mounts)

	for _, k := range keys {
		mount := mounts[k]
		if len(mount.PlayerConditions) > 0 {

			file.WriteString("[" + strconv.Itoa(mount.ID) + "] = {")

			for _, group := range mount.PlayerConditions {

				file.WriteString(" [\"" + group[0].Type + "\"]={")

				for _, condition := range group {
					file.WriteString(condition.Value + ",")
				}

				file.WriteString("},")
			}

			file.WriteString(" }, -- " + mount.Name + "\n")
		}
	}

	file.WriteString("}")

	defer file.Close()
}

func ExportColors(mounts map[int]*mount) {

	file := prepareLuaDB("colors.db.lua", "Colors")

	keys := getOrderedKeys(mounts)

	for _, k := range keys {
		mount := mounts[k]
		if len(mount.Colors) > 0 {
			file.WriteString("[" + strconv.Itoa(mount.ID) + "] = {")
			for _, group := range mount.Colors {
				file.WriteString(fmt.Sprintf(" {%v,%v,%v},", group[0], group[1], group[2]))
			}
			file.WriteString(" }, -- " + mount.Name + "\n")
		}
	}

	file.WriteString("}")

	defer file.Close()
}

func ExportRarities(mounts map[int]*mount) {

	file := prepareLuaDB("rarities.db.lua", "Rarities")

	keys := getOrderedKeys(mounts)

	for _, k := range keys {
		mount := mounts[k]
		if mount.Rarity != nil {
			file.WriteString("[" + strconv.Itoa(mount.ID) + "] = ")
			file.WriteString(fmt.Sprintf("%v", *mount.Rarity))
			file.WriteString(", -- " + mount.Name + "\n")
		}
	}

	file.WriteString("}")

	defer file.Close()
}
