package install

import (
	"context"
	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/tools"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:    "install",
		Aliases: []string{"i"},
		Usage:   "Detect system and install appropriate dotfiles packages",
		Action: func(ctx context.Context, c *cli.Command) error {
			if err := zsh(); err != nil {
				return err
			}

			conf, err := dotfiles.Load()

			if err != nil {
				return err
			}

			err = tools.Link()
			aquaDir := conf.GetToolPath("shared/aqua")

			if aquaDir != "" {
				if err = aqua(aquaDir); err != nil {
					return err
				}

				miseDir := conf.GetToolPath("shared/mise")

				if err = mise(miseDir); err != nil {
					return err
				}

				if err = npm(conf); err != nil {
					return err
				}
			}

			return err
		},
	}
}
