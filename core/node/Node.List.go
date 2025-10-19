package node

import (
	"fmt"
	"os"
	"path/filepath"
	"slices"
)

func (node *Node) List() (List, error) {
	var nodes List

	if !node.exists {
		return nodes, Error(
			fmt.Sprintf(
				"Node not found: %s",
				node.source,
			),
		)
	}

	if node.Type() != DirNode {
		return nodes, nil
	}

	entries, err := os.ReadDir(node.source)

	if err != nil {
		return nodes, err
	}

	for entry := range slices.Values(entries) {
		source := filepath.Join(node.source, entry.Name())

		sub := &Node{}
		sub.source = source
		err = sub.Sync()

		if err != nil {
			return nodes, err
		}

		nodes = append(nodes, sub)
	}

	return nodes, nil
}
