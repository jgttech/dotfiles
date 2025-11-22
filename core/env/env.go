package env

import (
	"fmt"
	"os"
	"path/filepath"
)

var (
	SEP           = string(os.PathSeparator)
	HOME          = os.Getenv("HOME")
	HOME_DIR      = filepath.Join(HOME, ".dotfiles")
	HOME_TOOLS    = filepath.Join(HOME_DIR, "tools")
	HOME_SEED     = filepath.Join(HOME_DIR, "seed")
	DOTFILES_YAML = filepath.Join(HOME_DIR, "dotfiles.yml")
	SEED          = func() string {
		_, err := os.Stat(HOME_SEED)

		if os.IsNotExist(err) {
			fmt.Println(err)
			return ""
		}

		content, err := os.ReadFile(HOME_SEED)

		if err != nil {
			return ""
		}

		return string(content)
	}()
)
