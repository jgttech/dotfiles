package stow

import (
	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/env"
	"os"
	"slices"
)

func detect() []string {
	packages := []string{}

	for _, file := range assert.Must(os.ReadDir(env.BASE)) {
		if file.IsDir() && !slices.Contains(env.STOW_IGNORE, file.Name()) {
			packages = append(packages, file.Name())
		}
	}

	return packages
}
