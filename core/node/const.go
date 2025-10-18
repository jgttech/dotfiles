package node

type NodeType int

const (
	UnknownNode NodeType = iota
	FileNode
	DirNode
)
