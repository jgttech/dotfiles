package notice

import (
	"fmt"
	"jgttech/dotfiles/core/tui/theme"
)

func Warning(msg string, a ...any) {
	printer(
		theme.Failure.SetString(theme.EXCLAMATION_ICON),
		fmt.Sprintf(msg, a...),
	)
}
