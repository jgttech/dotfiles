package spinner

import "jgttech/dotfiles/core/tui/spinner/tui"

func SetMsg(msg string) {
	if isActive() {
		state.program.Send(tui.Msg(msg))
	}
}
