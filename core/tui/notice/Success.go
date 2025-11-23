package notice

import (
	"fmt"
	"jgttech/dotfiles/core/tui/theme"
)

func Success(msg string, a ...any) {
	printer(
		theme.Success.SetString(theme.CHECK_ICON),
		fmt.Sprintf(msg, a...),
	)
}
