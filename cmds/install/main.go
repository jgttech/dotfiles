package install

import (
	"context"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "Install a particular type of dotfiles",
		Action: func(ctx context.Context, c *cli.Command) error {
			return nil
		},
	}
}
