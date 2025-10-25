package dotfiles

import (
	"dotfiles/cli/core/env"
	"path/filepath"
)

func (conf *Dotfiles) GetToolByName(name string) string {
	for key := range conf.Tools {
		if key == name {
			return filepath.Join(env.HOME_TOOLS, conf.Tools[key])
		}
	}

	return ""
}
