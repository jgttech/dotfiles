package spinner

import "fmt"

func StopWithSuccess(msg string, a ...any) {
	if !isActive() {
		return
	}

	SetSuccess()
	SetMsg(fmt.Sprintf(msg, a...))
	cleanup()
}
