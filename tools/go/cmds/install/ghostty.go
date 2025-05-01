package install

import (
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exceptions"
	"jgttech/dotfiles/src/file"
	"jgttech/dotfiles/src/os"
	"path"
)

func ghostty(build *cfg.Build) error {
	dir := path.Join(build.Home, "packages/ghostty/.config/ghostty")
	linuxFile := path.Join(dir, "config.linux")
	darwinFile := path.Join(dir, "config.darwin")
	configFile := path.Join(dir, "config")

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
