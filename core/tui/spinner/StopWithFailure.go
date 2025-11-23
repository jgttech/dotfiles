package spinner

import "fmt"

func StopWithFailure(msg string, a ...any) {
	if !isActive() {
		return
	}

	SetFailure()
	SetMsg(fmt.Sprintf(msg, a...))
	cleanup()
}
