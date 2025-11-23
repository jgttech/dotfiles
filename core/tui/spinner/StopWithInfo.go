package spinner

import "fmt"

func StopWithInfo(msg string, a ...any) {
	if !isActive() {
		return
	}

	SetInfo()
	SetMsg(fmt.Sprintf(msg, a...))
	cleanup()
}
