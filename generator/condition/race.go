package condition

func checkRace(mask int64) []Condition {

	var result []Condition

	if mask == 6130900294268439629 || mask == -6184943489809468494 {
		// skip full faction masks
		return result
	}

	if mask&0x4 > 0 {
		result = append(result, Condition{"race", "\"Dwarf\""})
	}
	if mask&0x20 > 0 {
		result = append(result, Condition{"race", "\"Tauren\""})
	}
	if mask&0x200 > 0 {
		result = append(result, Condition{"race", "\"BloodElf\""})
	}
	if mask&0x400 > 0 {
		result = append(result, Condition{"race", "\"Draenei\""})
	}
	if mask&0x800 > 0 {
		result = append(result, Condition{"race", "\"DarkIronDwarf\""})
	}
	if mask&0x20000000 > 0 {
		result = append(result, Condition{"race", "\"LightforgedDraenei\""})
	}
	if mask&0x40000000 > 0 {
		result = append(result, Condition{"race", "\"ZandalariTroll\""})
	}

	return result

}
