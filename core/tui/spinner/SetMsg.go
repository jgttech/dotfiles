package spinner

import "dotfiles/cli/core/tui/spinner/tui"

func SetMsg(msg string) {
	if isActive() {
		state.program.Send(tui.Msg(msg))
	}
}
