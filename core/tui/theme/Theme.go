package theme

import "github.com/charmbracelet/lipgloss"

const (
	// The check mark for success messages.
	CHECK_ICON = "✓"

	// The X for failure messages.
	CLOSE_ICON = "𐄂"

	// The diamond for info messages.
	DIAMOND_ICON = "❖"

	// The exclamation for warnings.
	EXCLAMATION_ICON = "!"

	// The arrow for prompts.
	RIGHT_ARROW_ICON = "❯"

	// The amber yellow color.
	AMBER_YELLOW = lipgloss.Color("#ffa726")

	// The dark amber background color.
	DARK_AMBER = lipgloss.Color("#4a3d1f")

	// The sky blue color.
	SKY_BLUE = lipgloss.Color("#5fb3f0")

	// The deep blue background color.
	DEEP_BLUE = lipgloss.Color("#1f2f4a")

	// The mint green color.
	MINT_GREEN = lipgloss.Color("#4ade80")

	// The dark forest background color.
	DARK_FOREST = lipgloss.Color("#1f4a2f")

	// The dark wine background color.
	DARK_WINE = lipgloss.Color("#5c0f0f")

	// The crimson red color.
	CRIMSON_RED = lipgloss.Color("#dc2626")

	// The teal blue color.
	TEAL_BLUE = lipgloss.Color("#14b8a6")
)

var (
	// Informational messages.
	Info = lipgloss.NewStyle().Foreground(SKY_BLUE).Background(DEEP_BLUE)

	// In-progress messages.
	Pending = lipgloss.NewStyle().Foreground(TEAL_BLUE)

	// Success messages.
	Success = lipgloss.NewStyle().Foreground(MINT_GREEN).Background(DARK_FOREST)

	// Warning messages.
	Warning = lipgloss.NewStyle().Foreground(AMBER_YELLOW).Background(DARK_AMBER)

	// Error messages.
	Failure = lipgloss.NewStyle().Foreground(CRIMSON_RED).Background(DARK_WINE)
)
