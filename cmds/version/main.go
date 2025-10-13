package version

import (
	"context"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "version",
		Usage: "Version of the Dotfiles CLI",
		Action: func(ctx context.Context, c *cli.Command) error {
			return nil
		},
	}
}
