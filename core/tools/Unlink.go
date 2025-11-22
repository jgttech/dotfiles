package tools

import (
	"dotfiles/cli/core/stow"
	"dotfiles/cli/core/tui/spinner"
	"fmt"
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

	spinner.Start("Unlinking tools...")

	for source := range slices.Values(sources) {
		fmt.Println(source.GetDirectory())

		// if err = source.Run(); err != nil && !stow.IsMissingPackages(err) {
		// 	spinner.StopWithFailure("Failed to while removing links")
		// 	return err
		// }
	}

	spinner.StopWithSuccess("Links removed")
	return nil
}
