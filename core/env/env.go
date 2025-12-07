package env

import (
	"os"
	"path/filepath"
)

var (
	OS_HOME       = os.Getenv("HOME")
	DOTFILES_HOME = filepath.Join(OS_HOME, ".dotfiles")
)

const (
	GIT_REPO   = "https://github.com/jgttech/dotfiles.git"
	GIT_BRANCH = "v5"
)
