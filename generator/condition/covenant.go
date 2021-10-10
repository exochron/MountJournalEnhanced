package condition

import (
    "strings"
)

func checkCovenant(record map[string]string) []Condition {
    description := record["Failure_description_lang"]

	if strings.Contains(description, "Kyrian") {
		return []Condition{Condition{"covenant", "1"}}
	}
	if strings.Contains(description, "Venthyr ") {
		return []Condition{Condition{"covenant", "2"}}
	}
	if strings.Contains(description, "Night Fae") {
		return []Condition{Condition{"covenant", "3"}}
	}
	if strings.Contains(description, "Necrolord") {
		return []Condition{Condition{"covenant", "4"}}
	}
	return nil
}
