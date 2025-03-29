package shell

import (
	"jgttech/dotfiles/src/exceptions"
	"os/exec"
)

func Python() (string, error) {
	pyPath, pyErr := exec.LookPath("python3")

	if pyErr == nil {
		return pyPath, nil
	}

	pyPath, pyErr = exec.LookPath("python")

	if pyErr == nil {
		return pyPath, nil
	}

	return "", exceptions.CommandNotFound("python3, python")
}
