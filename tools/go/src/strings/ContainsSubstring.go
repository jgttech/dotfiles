package strings

import (
	"slices"
	"strings"
)

func ContainsSubstring(list []string, sub string) bool {
	for item := range slices.Values(list) {
		if strings.Contains(item, sub) {
			return true
		}
	}

	return false
}
