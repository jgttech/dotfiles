package install

import (
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exceptions"
	"jgttech/dotfiles/src/file"
	"jgttech/dotfiles/src/os"
	"path"
)

func alacritty(build *cfg.Build) error {
	dir := path.Join(build.Home, "packages/alacritty/.config/alacritty")
	linuxFile := path.Join(dir, "alacritty.linux.toml")
	darwinFile := path.Join(dir, "alacritty.darwin.toml")
	configFile := path.Join(dir, "alacritty.toml")

	if os.Exists(configFile) {
		return nil
	}

	var targetFile string

	if os.IS_LINUX {
		targetFile = linuxFile
	} else if os.IS_DARWIN {
		targetFile = darwinFile
	}

	if targetFile == "" {
		return exceptions.FileNotFound(configFile + "." + os.UNAME)
	}

	if _, err := file.Copy(targetFile, configFile); err != nil {
		return err
	}

	return nil
}
