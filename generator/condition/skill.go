package condition

func checkSkill(skillID string) []Condition {
	if skillID != "0" {
		skill := Condition{"skill", skillID}
		return []Condition{skill}
	}
	return nil
}
