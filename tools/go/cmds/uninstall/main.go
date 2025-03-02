package uninstall

import (
	"context"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "uninstall",
		Usage: "Removes the system packages and resets the ZSHRC file. Does NOT uninstall the CLI.",
		Action: func(ctx context.Context, c *cli.Command) error {
			return nil
		},
	}
}
