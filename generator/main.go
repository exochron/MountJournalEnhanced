package main

import (
	"fmt"
	"mje_generator/db2reader"
)

func main() {
	conf := LoadConfig()

	fmt.Printf("Load Listfile.. ")
	listfile := LoadListfile()
	fmt.Printf("done.\n")

	casc := CascGateway{conf.Product, "enUS", conf.CacheDir}

	mounts := collectMounts(
		db2reader.ParseDB2(casc.LoadDB2("mount")),
		db2reader.ParseDB2(casc.LoadDB2("playercondition")),
		db2reader.ParseDB2(casc.LoadDB2("itemsparse")),
		db2reader.ParseDB2(casc.LoadDB2("itemeffect")),
		db2reader.ParseDB2(casc.LoadDB2("itemxitemeffect")),
		db2reader.ParseDB2(casc.LoadDB2("spellmisc")),
		listfile,
	)

	for _, ignoredId := range conf.Ignored {
		delete(mounts, ignoredId)
	}

	for mountId, rarity := range LoadRarities() {
		mounts[mountId].Rarity = rarity
	}

 	CollectTextures(
 		mounts,
 		casc,
 		db2reader.ParseDB2(casc.LoadDB2("mountxdisplay")),
 		db2reader.ParseDB2(casc.LoadDB2("creaturedisplayinfo")),
 	)

	wcmMap := LoadMountFamilies()
	conf.FamilyMap = GroupByFamily(conf.FamilyMap, mounts, wcmMap)

	ExportTradeable(mounts)
	ExportFamilies(conf.FamilyMap)
	ExportConditions(mounts)
	ExportColors(mounts)
	ExportRarities(mounts)
}
