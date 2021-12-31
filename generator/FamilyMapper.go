package main

import "strings"

type FamilyCategory struct {
	Name        string
	SubFamilies []FamilyCategory
	Mounts      map[int]mount
}

func matchById(mount mount, config []familyConfig) ([]familyConfig, bool) {
	hasMatch := false

	for cKey, family := range config {
		// check for mountId in config
		for _, mountId := range family.Ids {
			if mountId == mount.ID {
				config[cKey].Mounts = append(family.Mounts, mount)
				hasMatch = true
			}
		}

		// do the same for all sub categories
		if family.SubFamily != nil {
			hasSubMatch := false
			config[cKey].SubFamily, hasSubMatch = matchById(mount, family.SubFamily)
			if hasSubMatch {
				hasMatch = true
			}
		}
	}

	return config, hasMatch
}

func matchByWcmFamily(mount mount, wcmMountFamily string, config []familyConfig) ([]familyConfig, bool) {

	mountIcon := strings.ToLower(mount.Icon)
	hasMatch := false

	for cKey, family := range config {

		for _, wcmName := range family.Wcm {
			if wcmName == wcmMountFamily {
				if len(family.Icons) == 0 {
					config[cKey].Mounts = append(family.Mounts, mount)
					hasMatch = true
				} else {
					for _, icon := range family.Icons {
						if strings.Contains(mountIcon, icon) {
							config[cKey].Mounts = append(family.Mounts, mount)
							hasMatch = true
						}
					}
				}
			}
		}

		// do the same for all sub categories
		if family.SubFamily != nil {
			hasSubMatch := false
			config[cKey].SubFamily, hasSubMatch = matchByWcmFamily(mount, wcmMountFamily, family.SubFamily)
			if hasSubMatch {
				hasMatch = true
			}
		}
	}

	return config, hasMatch
}

func GroupByFamily(config []familyConfig, mounts map[int]*mount, wcmMap map[string]string) []familyConfig {

	for _, mount := range mounts {
		wasMatched := false
		wcmFamily, isWcmMapped := wcmMap[strings.ToLower(mount.Name)]
		config, wasMatched = matchById(*mount, config)
		if false == wasMatched && isWcmMapped {
			config, wasMatched = matchByWcmFamily(*mount, wcmFamily, config)
		}

		if false == wasMatched {
			if false == isWcmMapped {
				println("mount not available on warcraftmounts", mount.ID, mount.SpellID, mount.Name, mount.Icon)
			} else {
				println("no family found for", mount.ID, mount.SpellID, mount.Name, mount.Icon)
			}
		}
	}

	return config
}
