package spinner

import (
	"jgttech/dotfiles/core/tui/spinner/tui"
	"jgttech/dotfiles/core/tui/theme"
)

func SetWarning() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(
			theme.Warning.
				SetString(theme.EXCLAMATION_ICON).
				PaddingLeft(1).
				PaddingRight(1).
				Render(),
		),
	)
}
