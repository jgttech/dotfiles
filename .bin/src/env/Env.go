package env

import (
	"os"
	"path"
)

const (
	DIR = ".dotfiles"
)

var (
	BASE        = path.Join(os.Getenv("HOME"), DIR)
	STOW_IGNORE = []string{".git", ".bin", "tools"}
)
