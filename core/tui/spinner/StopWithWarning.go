package spinner

func StopWithWarning(msg string) {
	if !isActive() {
		return
	}

	SetWarning()
	SetMsg(msg)
	cleanup()
}
