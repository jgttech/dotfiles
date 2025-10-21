package tools

import (
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/stow"
	"dotfiles/cli/core/tui/spinner"
	"path/filepath"
	"slices"
	"strings"
)

// Detects the node.List of dotfiles tools that exists.
// Then it generates a stow.List from the node.List and
// returns it. This does NOT run GNU "stow", it just acts
// as a predicate builder for GNU "stow" and creates instances
// that can be used to generate symlinks using GNU "stow".
//
// Options passed to this function are applied to all GNU "stow"
// struct instances.
func getSources(options ...stow.Option) (stow.List, error) {
	list := stow.List{}
	nodes, err := getDetected()

	// Generates a new slice of options with the
	// "-d" (WithDirectory) set for the source, out
	// of the box.
	with := func(dir string) []stow.Option {
		return append(
			options,
			stow.WithDirectory(
				filepath.Join(env.HOME_TOOLS, dir),
			),
		)
	}

	shared, linux, macos :=
		stow.New(with("shared")...),
		stow.New(with("linux")...),
		stow.New(with("macos")...)

	if err != nil {
		return list, err
	}

	spinner.Start("Detecting sources...")

	for node := range slices.Values(nodes) {
		rel, err := filepath.Rel(env.HOME_TOOLS, node.Source())

		if err != nil {
			spinner.StopWithFailure("Failed detecting sources")
			return list, err
		}

		tokens := strings.Split(rel, env.SEP)
		namespace, tool := strings.TrimSpace(tokens[0]), tokens[1]

		switch namespace {
		case "shared":
			shared.Add(tool)
		case "linux":
			linux.Add(tool)
		case "macos":
			macos.Add(tool)
		}
	}

	// Add these sources.
	list = append(list, shared)
	list = append(list, linux)
	list = append(list, macos)

	spinner.StopWithSuccess("Detected sources")
	return list, err
}
