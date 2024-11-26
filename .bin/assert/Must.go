package assert

func Must[T any](data T, err error) T {
	if err != nil {
		panic(err)
	}

	return data
}
