package tool

import (
	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/tui/theme"
	"fmt"
)

func listTools(conf *dotfiles.Conf) error {
	for key := range conf.Tools {
		fmt.Printf(
			"%s %s\n",
			theme.
				Info.
				UnsetBackground().
				Render(theme.RIGHT_ARROW_ICON),
			key,
		)
	}

	return nil
}
