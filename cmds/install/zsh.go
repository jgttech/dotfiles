package install

import (
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/node"
	"fmt"
	"os"
	"path/filepath"
)

func zsh() error {
	zshrc, err := node.New(filepath.Join(os.Getenv("HOME"), ".zshrc"))

	if err != nil {
		return err
	}

	if zshrc.Exists() {
		if err = zshrc.Rename(fmt.Sprintf(".zshrc.%s.bak", env.TIMESTAMP)); err != nil {
			return err
		}
	}

	return nil
}
