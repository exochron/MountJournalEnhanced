package main

func main() {
	conf := LoadConfig()
	mounts := LoadFromWoWTools(conf.WoWToolsChannel)

	for _, ignoredId := range conf.Ignored {
		delete(mounts, ignoredId)
	}

	wcmMap := LoadMountFamilies()
	conf.FamilyMap = GroupByFamily(conf.FamilyMap, mounts, wcmMap)

	ExportTradeable(mounts)
	ExportFamilies(conf.FamilyMap)
	ExportConditions(mounts)
}
