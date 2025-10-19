package node

type Type int
type List []*Node

const (
	UnknownNode Type = iota
	FileNode
	DirNode
)
