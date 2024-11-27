package tpm

import (
	"fmt"
	_os "os"
	"path"

	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/exec"
	"jgttech/dotfiles/os"
)

func Install() {
	dir := path.Join(_os.Getenv("HOME"), ".tmux/plugins/tpm")

	if os.Exists(dir) {
		return
	}

	cfg := path.Join(_os.Getenv("HOME"), ".tmux.conf")

	cmd := exec.Cmd(fmt.Sprintf("git clone https://github.com/tmux-plugins/tpm %s", dir), exec.Stdio)
	assert.Will(cmd.Run())

	cmd = exec.Cmd(fmt.Sprintf("tmux source %s", cfg), exec.Stdio)
	assert.Will(cmd.Run())
}
