package dotfiles

import (
	"dotfiles/cli/core/env"
	"path/filepath"
)

func (dotfiles *Conf) GetToolDir(name string) string {
	for key := range dotfiles.Tools {
		if key == name {
			return filepath.Join(env.HOME_TOOLS, dotfiles.Tools[key])
		}
	}

	return ""
}
