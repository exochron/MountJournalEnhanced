package condition

type skill struct {
	value string
}
func (item skill) ToString() string {
	return "ADDON.playerHasProfession(" + item.value + ")"
}

func checkSkill(skillID string) []Condition {
	if skillID != "0" {
		skill := skill{skillID}
		return []Condition{skill}
	}
	return nil
}