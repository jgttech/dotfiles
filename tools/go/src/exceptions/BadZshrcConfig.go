package exceptions

import "fmt"

type badZshrcConfigException struct {
	msg string
}

func (exception *badZshrcConfigException) Error() string {
	return fmt.Sprintf("ZSH Error: %s", exception.msg)
}

func BadZshrcConfig(msg string) *badZshrcConfigException {
	return &badZshrcConfigException{msg}
}
