package notice

import (
	"fmt"
	"jgttech/dotfiles/core/tui/theme"
)

func Info(msg string, a ...any) {
	printer(
		theme.Info.SetString(theme.DIAMOND_ICON),
		fmt.Sprintf(msg, a...),
	)
}
