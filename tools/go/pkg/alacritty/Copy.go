package alacritty

import (
	"errors"
	"fmt"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/env"
	"jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/os"
	_os "os"

	"path"
	"runtime"
)

func Copy() {
	name := "alacritty." + runtime.GOOS + ".toml"
	base := path.Join(env.BASE_PATH, "alacritty", ".config", "alacritty")
	cfg := path.Join(base, "alacritty.toml")
	target := path.Join(base, name)

	if os.Exists(cfg) {
		_os.Remove(cfg)
	}

	if !os.Exists(target) {
		panic(errors.New(fmt.Sprintf("Alacritty config not found: '%s'", target)))
	}

	cmd := exec.Cmd(fmt.Sprintf("cp -v %s %s", target, cfg), exec.Stdio)
	assert.Will(cmd.Run())
}
