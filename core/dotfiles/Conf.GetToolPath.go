package dotfiles

import (
	"dotfiles/cli/core/env"
	"path/filepath"
	"strings"
)

func (dotfiles *Conf) GetToolPath(name string) string {
	for key := range dotfiles.Tools {
		if key == name {
			base := strings.Split(dotfiles.Tools[key], env.HOME)[0]
			base = strings.Split(base, name)[1][1:]
			base = filepath.Join(env.HOME, base)

			return base
		}
	}

	return ""
}
