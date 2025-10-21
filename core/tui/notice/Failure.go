package notice

import (
	"dotfiles/cli/core/tui/theme"
	"fmt"
)

func Failure(msg string, a ...any) {
	printer(
		theme.Failure.
			Background(theme.DARK_WINE).
			SetString(theme.CLOSE_ICON),
		fmt.Sprintf(msg, a...),
	)
}
