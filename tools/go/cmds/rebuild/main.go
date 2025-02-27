package rebuild

import (
	"context"
	"fmt"
	"path"

	"jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/install"

	"github.com/urfave/cli/v3"
)

func Command(build *install.Build) *cli.Command {
	return &cli.Command{
		Name:  "rebuild",
		Usage: "Rebuilds the CLI",
		Action: func(ctx context.Context, c *cli.Command) error {
			dir := path.Join(build.Home, build.Tools)
			sh := exec.Cmd(build.Cli, exec.Stdio)
			sh.Dir = dir

			fmt.Printf("DIR: %s\n", dir)

			return sh.Run()
		},
	}
}
