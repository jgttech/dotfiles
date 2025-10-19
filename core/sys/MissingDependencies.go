package sys

import (
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/lipgloss/table"
	"strconv"
)

type missingDependencies struct {
	dependencies []string
}

func (err *missingDependencies) Error() string {
	rows := [][]string{}

	for idx, dep := range err.dependencies {
		rows = append(rows, []string{strconv.Itoa(idx + 1), dep})
	}

	fg := lipgloss.Color("99")
	cell := lipgloss.NewStyle().Padding(0, 1).Width(14)
	even := cell.Foreground(lipgloss.Color("241"))
	odd := cell.Foreground(lipgloss.Color("245"))
	title := lipgloss.NewStyle().Bold(true).Foreground(fg)

	header := lipgloss.
		NewStyle().
		Foreground(fg).
		Bold(true).
		Align(lipgloss.Center)

	t := table.
		New().
		Border(lipgloss.NormalBorder()).
		BorderStyle(lipgloss.NewStyle().Foreground(fg)).
		StyleFunc(func(row, col int) lipgloss.Style {
			switch {
			case row == table.HeaderRow:
				return header
			case row%2 == 0:
				return even
			default:
				return odd
			}
		}).
		Headers("INDEX", "NAME").
		Rows(rows...)

	return "\n\n" + title.Render("Missing required dependencies:") + "\n" + t.Render() + "\n"
}

func MissingDependencies(dependencies []string) error {
	return &missingDependencies{dependencies}
}
