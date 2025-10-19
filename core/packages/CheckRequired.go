package packages

import "slices"

func CheckRequired(packages []string) (bool, []error) {
	missing := []error{}
	ok := false

	for pkg := range slices.Values(packages) {
		installed := IsInstalled(pkg)

		if !installed {
			missing = append(missing, Missing(pkg))
		}
	}

	ok = len(missing) == 0
	return ok, missing
}
