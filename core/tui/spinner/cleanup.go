package spinner

import (
	tea "github.com/charmbracelet/bubbletea"
	"jgttech/dotfiles/core/tui/spinner/tui"
)

func cleanup() {
	// Trigger a ESC key
	state.program.Send(tea.KeyMsg{Type: tea.KeyEsc})

	state.program.Quit()
	state.program.Wait()

	// About
	// This cleanup is a little odd because
	// I am having to deal with ensuring and
	// managing the existing state of things
	// before another iteration is triggered
	// if the spinner is used right after
	// being stopped

	// For memory leak purposes.
	state.program = nil
	state.model = tui.Model{}

	// Finally nil the state
	state = nil
}
