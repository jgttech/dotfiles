package stow

import (
	"dotfiles/cli/core/exec"
	"fmt"
	"strings"
)

// Constructs the GNU "stow" command based on the
// state of the configuration. The goal is to allow
// construction to be modular and composed when this
// method is called.
func (stow *Stow) Run() error {
	if len(stow.packages) == 0 {
		return MissingPackages()
	}

	tokens := []string{"stow"}

	if stow.replace {
		tokens = append(tokens, "-R")
	} else if stow.delete {
		tokens = append(tokens, "-D")
	}

	if stow.directory != "" {
		tokens = append(tokens, fmt.Sprintf("-d %s", stow.directory))
	}

	if stow.target != "" {
		tokens = append(tokens, fmt.Sprintf("-t %s", stow.target))
	}

	tokens = append(tokens, strings.Join(stow.packages, " "))
	cmd := strings.Join(tokens, " ")
	sh := exec.Cmd(cmd, exec.Stdio)

	return sh.Run()
}
