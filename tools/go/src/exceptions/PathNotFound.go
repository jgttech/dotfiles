package exceptions

import "fmt"

type pathNotFoundException struct {
	msg string
}

func (exception *pathNotFoundException) Error() string {
	return fmt.Sprintf("Path not found: '%s'", exception.msg)
}

func PathNotFound(msg string) *pathNotFoundException {
	return &pathNotFoundException{msg}
}
