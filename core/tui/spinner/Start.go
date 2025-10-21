package spinner

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"

	"dotfiles/cli/core/tui/spinner/tui"
)

func Start(msg string, a ...any) {
	var attempts uint8

	for state != nil {
		attempts++

		if attempts > 100 {
			if state != nil {
				cleanup()
			}
		}
	}

	model := tui.New(fmt.Sprintf(msg, a...))
	program := tea.NewProgram(model)

	state = &_state{}
	state.program = program
	state.model = model

	go (func() {
		if _, err := state.program.Run(); err != nil {
			// Reset the state.
			state = &_state{}

			// Display the error.
			fmt.Println(err)

			// Exit the program with error status.
			os.Exit(1)
		}
	})()
}
