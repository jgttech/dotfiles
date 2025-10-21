package notice

import (
	"dotfiles/cli/core/tui/theme"
	"fmt"
)

func Warning(msg string, a ...any) {
	printer(
		theme.Failure.SetString(theme.EXCLAMATION_ICON),
		fmt.Sprintf(msg, a...),
	)
}
