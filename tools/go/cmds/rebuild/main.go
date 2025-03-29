package rebuild

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/shell"
	"path"

	"github.com/urfave/cli/v3"
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "rebuild",
		Usage: fmt.Sprintf("Rebuilds the '%s' CLI.", build.Binary),
		Action: func(ctx context.Context, c *cli.Command) error {
			tools := path.Join(build.Tools, "build.py")
			python := assert.Must(shell.Python())

			cmd := exec.Cmd(fmt.Sprintf("%s %s", python, tools))
			cmd.Dir = build.Home

			return cmd.Run()
		},
	}
}
