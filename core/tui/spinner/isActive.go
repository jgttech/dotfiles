package spinner

func isActive() bool {
	return state != nil && state.program != nil
}
