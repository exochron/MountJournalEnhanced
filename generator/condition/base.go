package condition

type Condition interface {
	ToString() string
}

func NewConditions(conditionData map[string]string) [][]Condition {

	var result [][]Condition

	classes := checkClass(conditionData["ClassMask"])
	if len(classes) > 0 {
		result = append(result, classes)
	}

	skills := checkSkill(conditionData["SkillID[0]"])
	if len(skills) > 0 {
		result = append(result, skills)
	}

	races := checkRace(conditionData["RaceMask"])
	if len(races) > 0 {
		result = append(result, races)
	}

	return result
}
