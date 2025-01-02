package stow

import (
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/env"
	"os"
	"slices"
)

func detect() []string {
	packages := []string{}

	for _, file := range assert.Must(os.ReadDir(env.BASE_PATH)) {
		if file.IsDir() && !slices.Contains(env.STOW_IGNORE, file.Name()) {
			packages = append(packages, file.Name())
		}
	}

	return packages
}
