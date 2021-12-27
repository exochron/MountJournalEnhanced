package condition

import (
	"strings"
)

func checkCovenant(description string) []Condition {

	if strings.Contains(description, "Kyrian") {
		return []Condition{{"covenant", "1"}}
	}
	if strings.Contains(description, "Venthyr ") {
		return []Condition{{"covenant", "2"}}
	}
	if strings.Contains(description, "Night Fae") {
		return []Condition{{"covenant", "3"}}
	}
	if strings.Contains(description, "Necrolord") {
		return []Condition{{"covenant", "4"}}
	}
	return nil
}
