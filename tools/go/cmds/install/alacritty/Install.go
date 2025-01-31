package alacritty

import (
	"errors"
	"fmt"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/context"
	"jgttech/dotfiles/src/io"

	// "jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/os"
	_os "os"
	"path"
	"runtime"
)

const (
	dir        = "packages/alacritty/.config/alacritty"
	configFile = "alacritty.toml"
)

func Install(etx *context.ExecutionContext) {
	cfg := etx.Build.Config
	name := "alacritty." + runtime.GOOS + ".toml"
	base := path.Join(cfg.Base, dir)
	config := path.Join(base, configFile)
	target := path.Join(base, name)

	if os.Exists(config) {
		_os.Remove(config)
	}

	if !os.Exists(target) {
		panic(errors.New(fmt.Sprintf("Alacritty config not found: '%s'", target)))
	}

	// Copy the OS-specific config file into
	// the name of the standard config file.
	assert.Must(io.Copy(target, config))
}
