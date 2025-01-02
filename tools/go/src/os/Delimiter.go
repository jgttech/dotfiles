package os

import "runtime"

func Delimiter() string {
	sep := "/"

	if runtime.GOOS == "windows" {
		sep = "\\"
	}

	return sep
}
