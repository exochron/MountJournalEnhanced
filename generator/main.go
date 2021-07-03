package main

func main() {
	conf := LoadConfig()
	mounts := LoadFromWoWTools(conf.WoWToolsChannel)

	for _, ignoreSpellId := range conf.Ignored {
		delete(mounts, ignoreSpellId)
	}

	wcmMap := LoadMountFamilies()
	conf.FamilyMap = GroupByFamily(conf.FamilyMap, mounts, wcmMap)

	ExportTradeable(mounts)
	ExportFamilies(conf.FamilyMap)
	ExportConditions(mounts)
}
