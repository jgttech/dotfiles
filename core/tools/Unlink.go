package tools

import (
	"dotfiles/cli/core/stow"
	"os"
	"slices"
)

// Detects all the dotfiles tools and removes
// the (using GNU "stow") symlinks created in
// the system.
func Unlink() error {
	sources, err := getSources(
		stow.AsDelete,
		stow.WithTarget(os.Getenv("HOME")),
	)

	if err != nil {
		return err
	}

	for source := range slices.Values(sources) {
		if err = source.Run(); !stow.IsMissingPackages(err) {
			return err
		}
	}

	return nil
}
