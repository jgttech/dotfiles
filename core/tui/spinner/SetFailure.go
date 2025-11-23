package spinner

import (
	"jgttech/dotfiles/core/tui/spinner/tui"
	"jgttech/dotfiles/core/tui/theme"
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
