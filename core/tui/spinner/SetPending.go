package spinner

import "jgttech/dotfiles/core/tui/spinner/tui"

func SetPending() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(""),
	)
}
