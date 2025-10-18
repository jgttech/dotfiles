package node

import "fmt"

type nodeError struct {
	msg string
}

func (err *nodeError) Error() string {
	return fmt.Sprintf("[core/node] %s", err.msg)
}

func Error(msg string) error {
	return &nodeError{msg}
}
