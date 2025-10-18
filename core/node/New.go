package node

func New(source string) (*Node, error) {
	node := &Node{}

	node.source = source
	err := node.Sync()

	return node, err
}
