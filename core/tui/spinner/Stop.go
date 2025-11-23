package spinner

func Stop() {
	if !isActive() {
		return
	}

	cleanup()
}
