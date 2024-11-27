package stow

import (
	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/env"
	"jgttech/dotfiles/exec"
	"strings"
)

func Unlink() {
	cmd := exec.Cmd(strings.TrimSpace("stow -D " + strings.Join(detect(), " ")))
	cmd.Dir = env.BASE

	assert.Will(cmd.Run())
}
