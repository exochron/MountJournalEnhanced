package condition

func checkCovenant(covenantID string) []Condition {
	if covenantID != "0" {
		item := Condition{"covenant", covenantID}
		return []Condition{item}
	}
	return nil
}
