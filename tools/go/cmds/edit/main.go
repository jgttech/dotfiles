package edit

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exec"
	"path"
	"slices"

	"github.com/urfave/cli/v3"
)

func Command(build *cfg.Build) *cli.Command {
	var edit string

	return &cli.Command{
		Name:  "edit",
		Usage: "Loads the CLI into nvim.",
		Action: func(ctx context.Context, c *cli.Command) error {
			name := c.Args().First()

			if name == "" {
				edit = path.Join(build.Home, build.Tools)
			}

			if slices.Contains(build.Packages, name) {
				edit = path.Join(build.Home, "packages", name)
			}

			if edit == "" {
				fmt.Println(fmt.Sprintf("Nothing to edit for '%s'", name))
				return nil
			}

			return exec.
				Cmd(
					fmt.Sprintf("nvim %s", edit),
					exec.Stdio,
					exec.Dir(edit),
				).
				Run()
		},
	}
}
