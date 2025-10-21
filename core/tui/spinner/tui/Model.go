package tui

import (
	"github.com/charmbracelet/bubbles/spinner"
	"github.com/charmbracelet/lipgloss"
)

type Option func(*Model)

type Error error

type Msg string

type Icon string

type Model struct {
	Spinner      spinner.Model
	PendingStyle lipgloss.Style
	IconStyle    lipgloss.Style
	Icon         string
	Msg          string
	Exit         bool
	Err          error
}
