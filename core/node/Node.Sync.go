package node

import "os"

// Checks the instance state and updates
// it based on the system checks. A good use
// of this is when you need to re-check the state
// of a node after a file system change.
func (node *Node) Sync() error {
	if node.source == "" {
		return Error("(*Node).source is missing.")
	}

	stat, err := os.Stat(node.source)

	node.exists = err == nil
	node.node = UnknownNode

	if stat != nil {
		if stat.IsDir() {
			node.node = DirNode
		} else {
			node.node = FileNode
		}
	}

	return err
}
