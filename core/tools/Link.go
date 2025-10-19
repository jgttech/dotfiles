package tools

import (
	"dotfiles/cli/core/stow"
	"os"
	"slices"
)

// Detects all the dotfiles tools and creates
// the GNU "stow" symlinks by running the GNU
// "stow" command(s) for each of the dotfiles
// tools sources.
func Link() error {
	sources, err := getSources(
		stow.AsReplace,
		stow.WithTarget(os.Getenv("HOME")),
	)

	if err != nil {
		return err
	}

	for source := range slices.Values(sources) {
		if err = source.Run(); err != nil && !stow.IsMissingPackages(err) {
			return err
		}
	}

	return nil
}
