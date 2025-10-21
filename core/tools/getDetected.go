package tools

import (
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/node"
	"dotfiles/cli/core/tui/notice"
	"dotfiles/cli/core/tui/spinner"
	"dotfiles/cli/core/tui/theme"
	"path/filepath"
	"runtime"
	"slices"
)

// Returns a node.List (type for []*node.Node) containing
// an instance that represents the location of each of the
// dotfiles tools in the system.
func getDetected() (node.List, error) {
	spinner.Start("Detecting tools...")
	var tools node.List

	sources := []string{
		filepath.Join(env.HOME_TOOLS, "shared"),
		filepath.Join(env.HOME_TOOLS, runtime.GOOS),
	}

	spinner.StopWithSuccess("Tools detected")
	ttl := 0

	for source := range slices.Values(sources) {
		element, err := node.New(source)
		source := element.Source()
		spinner.Start("Searching %s", source)

		if err != nil {
			spinner.StopWithFailure("Failed searching %s", source)
			return tools, err
		}

		spinner.StopWithSuccess("Found %s", source)

		if element.Exists() {
			subelements, err := element.List()
			size := len(subelements)
			ttl += size

			spinner.Start("%d tools", size)

			if err != nil {
				spinner.StopWithFailure("Failed detecting tools")
				return tools, err
			}

			spinner.StopWithSuccess("Detected %d tools", size)

			for sub := range slices.Values(subelements) {
				tools = append(tools, sub)
				notice.Info("%s %s", theme.RIGHT_ARROW_ICON, sub.Source())
			}
		} else {
			spinner.StopWithWarning("No tools found")
		}
	}

	notice.Success("%d total tools found", ttl)
	return tools, nil
}
