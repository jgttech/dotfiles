package tools

import (
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/node"
	"path/filepath"
	"runtime"
	"slices"
)

// Returns a node.List (type for []*node.Node) containing
// an instance that represents the location of each of the
// dotfiles tools in the system.
func getDetected() (node.List, error) {
	var tools node.List

	sources := []string{
		filepath.Join(env.HOME_TOOLS, "shared"),
		filepath.Join(env.HOME_TOOLS, runtime.GOOS),
	}

	for source := range slices.Values(sources) {
		element, err := node.New(source)

		if err != nil {
			return tools, err
		}

		if element.Exists() {
			subelements, err := element.List()

			if err != nil {
				return tools, err
			}

			for sub := range slices.Values(subelements) {
				tools = append(tools, sub)
			}
		}
	}

	return tools, nil
}
