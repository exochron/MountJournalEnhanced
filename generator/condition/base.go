package condition

type Condition struct {
	Type  string
	Value string
}

func NewConditions(race_mask int64, failure_description string, class_mask int32, skill_id int32) [][]Condition {

	var result [][]Condition

	classes := checkClass(int(class_mask))
	if len(classes) > 0 {
		result = append(result, classes)
	}

	skills := checkSkill(int(skill_id))
	if len(skills) > 0 {
		result = append(result, skills)
	}

	races := checkRace(race_mask)
	if len(races) > 0 {
		result = append(result, races)
	}

	covenants := checkCovenant(failure_description)
	if len(covenants) > 0 {
		result = append(result, covenants)
	}

	return result
}
