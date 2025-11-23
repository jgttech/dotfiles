package tui

import (
	"github.com/charmbracelet/bubbles/spinner"
	"jgttech/dotfiles/core/tui/theme"
	"time"
)

func New(msg string) Model {
	m := Model{}

	// A default message is no message is set.
	m.Msg = "Working, please wait..."

	// Central control of the style.
	m.IconStyle = theme.Info
	m.PendingStyle = theme.Pending

	m.Spinner = spinner.New()

	m.Spinner.Spinner = spinner.Spinner{
		FPS: time.Second / 10,
		Frames: []string{
			"   ",
			"❯  ",
			"❯❯ ",
			"❯❯❯",
			" ❯❯",
			"  ❯",
		},
	}

	m.Spinner.Style = m.PendingStyle

	if msg != "" {
		m.Msg = msg
	}

	return m
}
