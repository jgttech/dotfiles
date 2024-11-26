package uninstall

import (
	"context"
	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/env"
	"jgttech/dotfiles/exec"
	"os"
	"slices"
	"strings"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "uninstall",
		Action: func(ctx context.Context, c *cli.Command) error {
			stow := []string{}

			for _, file := range assert.Must(os.ReadDir(env.BASE)) {
				if file.IsDir() && !slices.Contains(env.STOW_IGNORE, file.Name()) {
					stow = append(stow, file.Name())
				}
			}

			cmd := exec.Cmd("stow -D "+strings.Join(stow, " "), exec.Stdio)
			cmd.Dir = env.BASE

			if err := cmd.Run(); err != nil {
				return err
			}

			return os.RemoveAll(env.BASE)
		},
	}
}
