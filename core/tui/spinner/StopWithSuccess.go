package spinner

func StopWithSuccess(msg string) {
	if !isActive() {
		return
	}

	SetSuccess()
	SetMsg(msg)
	cleanup()
}
