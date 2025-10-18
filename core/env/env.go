package env

import (
	"os"
	"path/filepath"
)

var (
	HOME       = os.Getenv("HOME")
	HOME_DIR   = filepath.Join(HOME, ".dotfiles")
	HOME_TOOLS = filepath.Join(HOME_DIR, "tools")
)
