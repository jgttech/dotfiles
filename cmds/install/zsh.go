package install

import (
	"dotfiles/cli/core/node"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"time"
)

func zsh() error {
	zshrc, err := node.New(filepath.Join(os.Getenv("HOME"), ".zshrc"))

	if err != nil {
		return err
	}

	if zshrc.Exists() {
		timestamp := strconv.Itoa(int(time.Now().UnixNano()))
		if err = zshrc.Rename(fmt.Sprintf(".zshrc.%s.bak", timestamp)); err != nil {
			return err
		}
	}

	return nil
}
