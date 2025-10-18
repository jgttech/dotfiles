package tools

import (
	"dotfiles/cli/core/assert"
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/node"
	"path/filepath"
	"runtime"
	"slices"
)

func Detect() ([]*node.Node, error) {
	var tools []*node.Node

	sources := []string{
		filepath.Join(env.HOME_TOOLS, "shared"),
		filepath.Join(env.HOME_TOOLS, runtime.GOOS),
	}

	for source := range slices.Values(sources) {
		element := assert.Must(node.New(source))

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
