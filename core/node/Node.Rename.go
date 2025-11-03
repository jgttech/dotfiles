package node

import (
	"os"
	"path/filepath"
)

func (node *Node) Rename(name string) error {
	dir := filepath.Dir(node.source)
	return os.Rename(node.source, filepath.Join(dir, name))
}
