package spinner

import (
	"jgttech/dotfiles/core/tui/spinner/tui"
	"jgttech/dotfiles/core/tui/theme"
)

func SetSuccess() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(
			theme.Success.
				SetString(theme.CHECK_ICON).
				PaddingLeft(1).
				PaddingRight(1).
				Render(),
		),
	)
}
