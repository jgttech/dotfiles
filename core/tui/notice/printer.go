package notice

import (
	"fmt"

	"github.com/charmbracelet/lipgloss"
)

var text = lipgloss.NewStyle().Faint(true)

func printer(icon lipgloss.Style, msg string) {
	fmt.Println(
		icon.PaddingLeft(1).PaddingRight(1).Render(),
		text.Render(msg),
	)
}
