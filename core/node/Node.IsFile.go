package node

func (node *Node) IsFile() bool {
	return node.node == FileNode
}
