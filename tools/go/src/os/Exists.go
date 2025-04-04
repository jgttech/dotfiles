package os

import (
	"errors"
	"os"
)

func Exists(filePath string) bool {
	_, err := os.Stat(filePath)
	return !errors.Is(err, os.ErrNotExist)
}
