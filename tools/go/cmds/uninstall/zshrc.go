package uninstall

import (
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/file"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"
)

func zshrc(build *cfg.Build) error {
	from := path.Join(HOME, build.Zshrc)

	if !_os.Exists(from) {
		return nil
	}

	to := path.Join(HOME, ".zshrc")

	if _, err := file.Copy(from, to); err != nil {
		return err
	}

	if err := os.Remove(from); err != nil {
		return err
	}

	return nil
}
