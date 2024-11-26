package assert

func Catch(err error) {
	if err != nil {
		panic(err)
	}
}
