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

	if isLinux {
		targetFile = linuxFile
	} else if isDarwin {
		targetFile = darwinFile
	}

	if targetFile == "" {
		return exceptions.FileNotFound(configFile + "." + OS)
	}

	if _, err := file.Copy(targetFile, configFile); err != nil {
		return err
	}

	return nil
}
