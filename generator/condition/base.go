package condition

type Condition struct {
	Type  string
	Value string
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

	covenants := checkCovenant(conditionData["CovenantID"])
	if len(covenants) > 0 {
		result = append(result, covenants)
	}

	return result
}
