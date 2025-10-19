package stow

import "errors"

type missingPackages struct{}

func (err *missingPackages) Error() string {
	return "[core/stow] Missing package(s)"
}

// Returns an error stating that there are no
// packages found for the "core/stow" modules
// "(*Stow).Run()" command.
func MissingPackages() error {
	return &missingPackages{}
}

func IsMissingPackages(err error) bool {
	var target *missingPackages
	return errors.As(err, &target)
}
