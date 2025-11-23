package spinner

import (
	tea "github.com/charmbracelet/bubbletea"
	"jgttech/dotfiles/core/tui/spinner/tui"
)

type _state struct {
	model   tui.Model
	program *tea.Program
}

var state *_state
