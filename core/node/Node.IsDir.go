package node

func (node *Node) IsDir() bool {
	return node.node == DirNode
}
