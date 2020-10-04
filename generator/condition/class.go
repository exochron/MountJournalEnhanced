package condition

import "strconv"

type class struct {
	value string
}

func (item class) ToString() string {
	return "ADDON.playerIsClass(\"" + item.value + "\")"
}

func checkClass(classMask string) []Condition {

	var result []Condition

	mask, _ := strconv.Atoi(classMask)
	if mask&0x2 > 0 {
		result = append(result, class{"PALADIN"})
	}
	if mask&0x4 > 0 {
		result = append(result, class{"HUNTER"})
	}
	if mask&0x8 > 0 {
		result = append(result, class{"ROGUE"})
	}
	if mask&0x10 > 0 {
		result = append(result, class{"PRIEST"})
	}
	if mask&0x20 > 0 {
		result = append(result, class{"DEATHKNIGHT"})
	}
	if mask&0x40 > 0 {
		result = append(result, class{"SHAMAN"})
	}
	if mask&0x80 > 0 {
		result = append(result, class{"MAGE"})
	}
	if mask&0x100 > 0 {
		result = append(result, class{"WARLOCK"})
	}
	if mask&0x200 > 0 {
		result = append(result, class{"MONK"})
	}
	if mask&0x400 > 0 {
		result = append(result, class{"DRUID"})
	}
	if mask&0x800 > 0 {
		result = append(result, class{"DEMONHUNTER"})
	}

	return result
}
