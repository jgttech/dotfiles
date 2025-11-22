package env

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
)

var (
	SEP            = string(os.PathSeparator)
	HOME           = os.Getenv("HOME")
	HOME_DIR       = filepath.Join(HOME, ".dotfiles")
	HOME_TOOLS     = filepath.Join(HOME_DIR, "tools")
	HOME_TIMESTAMP = filepath.Join(HOME_DIR, "install.timetamp")
	DOTFILES_YAML  = filepath.Join(HOME_DIR, "dotfiles.yml")
	TIMESTAMP      = func() string {
		_, err := os.Stat(HOME_TIMESTAMP)

		if os.IsNotExist(err) {
			fmt.Println(err)
			return ""
		}

		content, err := os.ReadFile(HOME_TIMESTAMP)

		if err != nil {
			log.Fatalln(err)
			return ""
		}

		return string(content)
	}()
)
