package stow

import (
	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/env"
	"jgttech/dotfiles/exec"
	"strings"
)

func Link() {
	cmd := exec.Cmd(strings.TrimSpace("stow " + strings.Join(detect(), " ")))
	cmd.Dir = env.BASE

	assert.Will(cmd.Run())
}
