package exceptions

import "fmt"

type commandNotFoundException struct {
	msg string
}

func (exception *commandNotFoundException) Error() string {
	return fmt.Sprintf("Command not found: '%s'", exception.msg)
}

func CommandNotFound(msg string) *commandNotFoundException {
	return &commandNotFoundException{msg}
}
