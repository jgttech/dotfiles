package spinner

import (
	"dotfiles/cli/core/tui/spinner/tui"
	"dotfiles/cli/core/tui/theme"
)

func SetFailure() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(
			theme.Failure.
				SetString(theme.CLOSE_ICON).
				PaddingLeft(1).
				PaddingRight(1).
				Render(),
		),
	)
}
