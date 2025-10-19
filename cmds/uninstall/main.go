package uninstall

import (
	"context"
	"dotfiles/cli/core/tools"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:    "uninstall",
		Aliases: []string{"u"},
		Usage:   "Detect system and remove appropriate dotfiles packages",
		Action: func(ctx context.Context, c *cli.Command) error {
			err := tools.Unlink()

			if err == nil {
				fmt.Println("Done")
			}

			return err
		},
	}
}
