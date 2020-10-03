package main

import (
	"log"
	"os"
	"sort"
	"strconv"
)

func (m mount) WriteToFile(file *os.File)  {
	file.WriteString("[" + strconv.Itoa(m.SpellID) + "] = true, -- " + m.Name + "\n")
}

func prepareLuaDB(filename string, varname string) *os.File {

	file, err := os.OpenFile(filename, os.O_TRUNC|os.O_WRONLY|os.O_CREATE, 0755)

	if err != nil {
		log.Fatal(err)
	}

	file.WriteString("local ADDON_NAME, ADDON = ...\n\n")
	file.WriteString("ADDON.DB." + varname + " = {\n")

	return file
}

func getOrderedKeys(list map[int]mount) []int {
	keys := make([]int, 0, len(list))
	for k := range list {
		keys = append(keys, k)
	}
	sort.Ints(keys)

	return keys
}

func ExportTradeable(mounts map[int]mount) {
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
		file.WriteString("[\""+c.Name+"\"] = {\n")

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
