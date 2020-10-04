package condition

import "strconv"

type race struct {
	value string
}

func (item race) ToString() string {
	return "ADDON.playerIsRace(\"" + item.value + "\")"
}

func checkRace(raceMask string) []Condition {

	var result []Condition

	mask, _ := strconv.Atoi(raceMask)
	if mask == 6130900294268439629 || mask == -6184943489809468494 {
		// skip full faction masks
		return result
	}

	if mask&0x4 > 0 {
		result = append(result, race{"Dwarf"})
	}
	if mask&0x20 > 0 {
		result = append(result, race{"Tauren"})
	}
	if mask&0x200 > 0 {
		result = append(result, race{"BloodElf"})
	}
	if mask&0x400 > 0 {
		result = append(result, race{"Draenei"})
	}
	if mask&0x800 > 0 {
		result = append(result, race{"DarkIronDwarf"})
	}
	if mask&0x20000000 > 0 {
		result = append(result, race{"LightforgedDraenei"})
	}
	if mask&0x40000000 > 0 {
		result = append(result, race{"ZandalariTroll"})
	}

	return result

}