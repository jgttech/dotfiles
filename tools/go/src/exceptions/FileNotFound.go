package exceptions

import "fmt"

type fileNotFoundException struct {
	msg string
}

func (exception *fileNotFoundException) Error() string {
	return fmt.Sprintf("File not found: '%s'", exception.msg)
}

func FileNotFound(msg string) *fileNotFoundException {
	return &fileNotFoundException{msg}
}
