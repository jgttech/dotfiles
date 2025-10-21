package notice

import (
	"dotfiles/cli/core/tui/theme"
	"fmt"
)

func Success(msg string, a ...any) {
	printer(
		theme.Success.SetString(theme.CHECK_ICON),
		fmt.Sprintf(msg, a...),
	)
}
