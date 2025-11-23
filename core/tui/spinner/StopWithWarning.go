package spinner

import "fmt"

func StopWithWarning(msg string, a ...any) {
	if !isActive() {
		return
	}

	SetWarning()
	SetMsg(fmt.Sprintf(msg, a...))
	cleanup()
}
