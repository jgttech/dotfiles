package uninstall

import (
	"context"
	"jgttech/dotfiles/src/pkg/stow"
	"jgttech/dotfiles/src/env"
	"os"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	var destroy bool

	return &cli.Command{
		Name: "uninstall",
		Flags: []cli.Flag{
			&cli.BoolFlag{
				Name:        "destroy",
				Usage:       "Indicates that you want to delete the repo, locally.",
				Destination: &destroy,
			},
		},
		Action: func(ctx context.Context, c *cli.Command) error {
			stow.Unlink()

			if destroy {
				return os.RemoveAll(env.BASE)
			}

			return nil
		},
	}
}
