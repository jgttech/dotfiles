package spinner

import "dotfiles/cli/core/tui/spinner/tui"

func SetPending() {
	if !isActive() {
		return
	}

	state.program.Send(
		tui.Icon(""),
	)
}
