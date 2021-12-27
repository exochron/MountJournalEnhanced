package condition

import "fmt"

func checkSkill(skillID int) []Condition {
	if skillID != 0 {
		skill := Condition{"skill", fmt.Sprint(skillID)}
		return []Condition{skill}
	}
	return nil
}
