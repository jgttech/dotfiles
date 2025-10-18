package pkg

import "fmt"

type missingPkg struct {
	msg string
}

func (err *missingPkg) Error() string {
	return fmt.Sprintf("[core/pkg] Missing package: %s", err.msg)
}

func Missing(name string) error {
	return &missingPkg{name}
}
