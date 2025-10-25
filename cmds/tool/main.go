package tool

import (
	"context"
	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/exec"
	"errors"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:    "tool",
		Aliases: []string{"t"},
		Usage:   "Opens IDE in that tools home path",
		Action: func(ctx context.Context, c *cli.Command) error {
			name := c.Args().First()

			fmt.Println("name:", name)

			conf, err := dotfiles.Load()

			if err != nil {
				return err
			}

			if name == "" {
				return errors.New("An argument is required")
			}

			dir := conf.GetToolByName(name)
			fmt.Println("dir:", dir)

			if dir == "" {
				return errors.New("Invalid tool name")
			}

			cmd := exec.Cmd("nvim .", exec.Dir(dir), exec.Stdio)

			return cmd.Run()
		},
	}
}
