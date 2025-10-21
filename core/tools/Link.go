package tools

import (
	"dotfiles/cli/core/stow"
	"dotfiles/cli/core/tui/spinner"
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

	spinner.Start("Linking tools...")

	for source := range slices.Values(sources) {
		if err = source.Run(); err != nil && !stow.IsMissingPackages(err) {
			spinner.StopWithFailure("Failed to while creating links")
			return err
		}
	}

	spinner.StopWithSuccess("Links created")
	return nil
}
