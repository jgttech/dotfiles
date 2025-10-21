package notice

import (
	"dotfiles/cli/core/tui/theme"
	"fmt"
)

func Info(msg string, a ...any) {
	printer(
		theme.Info.SetString(theme.DIAMOND_ICON),
		fmt.Sprintf(msg, a...),
	)
}
