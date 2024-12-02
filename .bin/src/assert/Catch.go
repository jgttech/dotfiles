package assert

func Will(err error) {
	if err != nil {
		panic(err)
	}
}
