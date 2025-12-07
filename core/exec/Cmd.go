package exec

import (
	"os/exec"
	"strings"
)

type option func(*exec.Cmd)

func Cmd(cmd string, opts ...option) *exec.Cmd {
	var args []string
	var builder strings.Builder
	var inSingle, inDouble, inBacktick bool

	for _, ch := range cmd {
		switch {
		case ch == '\'' && !inDouble && !inBacktick:
			inSingle = !inSingle
			// Don't write the quote character
		case ch == '"' && !inSingle && !inBacktick:
			inDouble = !inDouble
			// Don't write the quote character
		case ch == '`' && !inSingle && !inDouble:
			inBacktick = !inBacktick
			// Don't write the quote character
		case ch == ' ' && !inSingle && !inDouble && !inBacktick:
			if builder.Len() > 0 {
				args = append(args, builder.String())
				builder.Reset()
			}
		default:
			builder.WriteRune(ch)
		}
	}

	if builder.Len() > 0 {
		args = append(args, builder.String())
	}

	proc := exec.Command(args[0], args[1:]...)

	for _, fn := range opts {
		fn(proc)
	}

	return proc
}
