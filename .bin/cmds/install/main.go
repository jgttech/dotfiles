package install

import (
	"context"
	"jgttech/dotfiles/alacritty"
	"jgttech/dotfiles/stow"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "install",
		Action: func(ctx context.Context, c *cli.Command) error {
			alacritty.Copy()
			stow.Link()

			return nil
		},
	}
}
