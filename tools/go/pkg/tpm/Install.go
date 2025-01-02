package tpm

import (
	"fmt"
	_os "os"
	"path"

	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/os"
)

func Install() {
	dir := path.Join(_os.Getenv("HOME"), ".tmux/plugins/tpm")

	if os.Exists(dir) {
		return
	}

	cmd := exec.Cmd(fmt.Sprintf("git clone https://github.com/tmux-plugins/tpm %s", dir), exec.Stdio)
	assert.Will(cmd.Run())
}
