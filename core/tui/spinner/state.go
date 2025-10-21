package spinner

import (
	"dotfiles/cli/core/tui/spinner/tui"
	tea "github.com/charmbracelet/bubbletea"
)

type _state struct {
	model   tui.Model
	program *tea.Program
}

var state *_state
