package spinner

import (
	"jgttech/dotfiles/core/tui/spinner/tui"
	"jgttech/dotfiles/core/tui/theme"
)

func SetInfo() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(
			theme.Info.
				SetString(theme.DIAMOND_ICON).
				PaddingLeft(1).
				PaddingRight(1).
				Render(),
		),
	)
}
