package spinner

func StopWithFailure(msg string) {
	if !isActive() {
		return
	}

	SetFailure()
	SetMsg(msg)
	cleanup()
}
