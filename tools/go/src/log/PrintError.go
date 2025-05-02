package log

import "fmt"

const (
	errorTmpl = "[DOTFILES ERROR]\n%s\n"
)

func PrintError(msg string) {
	fmt.Sprintf(errorTmpl, msg)
}
