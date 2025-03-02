package install

import (
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exceptions"
	"jgttech/dotfiles/src/file"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"
)

func zshrc(build *cfg.Build) error {
	from := path.Join(HOME, ".zshrc")

	if _os.Exists(from) && build.Zshrc == "" {
		return exceptions.BadZshrcConfig("Build 'zshrc' missing.")
	}

	if !_os.Exists(from) && build.Zshrc != "" {
		return exceptions.BadZshrcConfig("Build 'zshrc' should not be set.")
	}

	if build.Zshrc == "" {
		return nil
	}

	to := path.Join(HOME, build.Zshrc)

	if _, err := file.Copy(from, to); err != nil {
		return err
	}

	if err := os.Remove(from); err != nil {
		return err
	}

	return nil
}
