package install

import (
	"dotfiles/cli/core/exec"
	"fmt"
	"strings"
)

func npm() error {
	dependencies := []string{
		"npm",
		"pnpm",
		"yarn",
		"bun",
		"@tailwindcss/language-server",
		"@anthropic-ai/claude-code",
	}

	command := fmt.Sprintf("zsh -c \"source ~/.zshrc; npm i -g %s\"", strings.Join(dependencies, " "))
	cmd := exec.Cmd(command, exec.Stdio)

	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
