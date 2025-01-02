package stow

import (
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/env"
	"jgttech/dotfiles/src/exec"
	"strings"
)

func Unlink() {
	cmd := exec.Cmd(strings.TrimSpace("stow -D " + strings.Join(detect(), " ")))
	cmd.Dir = env.BASE_PATH

	assert.Will(cmd.Run())
}
