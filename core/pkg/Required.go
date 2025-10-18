package pkg

func Required(name string) error {
	installed := IsInstalled(name)

	if !installed {
		return Missing(name)
	}

	return nil
}
