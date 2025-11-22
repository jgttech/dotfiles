package uninstall

import (
	"dotfiles/cli/core/env"
	"fmt"
	"os"
	"path/filepath"
)

func zsh() error {
	filename := fmt.Sprintf(".zshrc.%s.bak", env.SEED)
	backup := filepath.Join(env.HOME, filename)
	origin := filepath.Join(env.HOME, ".zshrc")

	if _, err := os.Stat(backup); os.IsNotExist(err) {
		fmt.Println("Failed to find backup .zshrc:", backup)
		return nil
	}

	err := os.Rename(backup, origin)
	return err
}
