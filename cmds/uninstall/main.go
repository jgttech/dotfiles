package uninstall

import (
	"context"
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/tools"
	"fmt"
	"os"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:    "uninstall",
		Aliases: []string{"u"},
		Usage:   "Detect system and remove appropriate dotfiles packages",
		Action: func(ctx context.Context, c *cli.Command) error {
			if err := zsh(); err != nil {
				return err
			}

			err := tools.Unlink()

			if err == nil {
				fmt.Println("Done")
			}

			if _, err := os.Stat(env.HOME_SEED); os.IsNotExist(err) {
				return nil
			}

			err = os.Remove(env.HOME_SEED)
			return err
		},
	}
}
