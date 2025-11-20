package install

import (
	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/exec"
	"fmt"
	"strings"
)

func npm(conf *dotfiles.Conf) error {
	command := fmt.Sprintf("zsh -c \"source ~/.zshrc; npm i -g %s\"", strings.Join(conf.Npm, " "))
	cmd := exec.Cmd(command, exec.Stdio)

	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
