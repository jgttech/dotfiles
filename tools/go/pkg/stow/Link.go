package stow

import (
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/env"
	"jgttech/dotfiles/src/exec"
	"strings"
)

func Link() {
	cmd := exec.Cmd(strings.TrimSpace("stow " + strings.Join(detect(), " ")))
	cmd.Dir = env.BASE_PATH

	assert.Will(cmd.Run())
}
