package condition

func checkClass(mask int) []Condition {

	var result []Condition

	if mask&0x1 > 0 {
		result = append(result, Condition{"class", "\"WARRIOR\""})
	}
	if mask&0x2 > 0 {
		result = append(result, Condition{"class", "\"PALADIN\""})
	}
	if mask&0x4 > 0 {
		result = append(result, Condition{"class", "\"HUNTER\""})
	}
	if mask&0x8 > 0 {
		result = append(result, Condition{"class", "\"ROGUE\""})
	}
	if mask&0x10 > 0 {
		result = append(result, Condition{"class", "\"PRIEST\""})
	}
	if mask&0x20 > 0 {
		result = append(result, Condition{"class", "\"DEATHKNIGHT\""})
	}
	if mask&0x40 > 0 {
		result = append(result, Condition{"class", "\"SHAMAN\""})
	}
	if mask&0x80 > 0 {
		result = append(result, Condition{"class", "\"MAGE\""})
	}
	if mask&0x100 > 0 {
		result = append(result, Condition{"class", "\"WARLOCK\""})
	}
	if mask&0x200 > 0 {
		result = append(result, Condition{"class", "\"MONK\""})
	}
	if mask&0x400 > 0 {
		result = append(result, Condition{"class", "\"DRUID\""})
	}
	if mask&0x800 > 0 {
		result = append(result, Condition{"class", "\"DEMONHUNTER\""})
	}
	if mask&0x1000 > 0 {
		result = append(result, Condition{"class", "\"EVOKER\""})
	}

	return result
}
