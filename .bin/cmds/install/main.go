package install

import (
	"context"
	"jgttech/dotfiles/pkg/alacritty"
	"jgttech/dotfiles/pkg/stow"
	"jgttech/dotfiles/pkg/tpm"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "install",
		Action: func(ctx context.Context, c *cli.Command) error {
			alacritty.Copy()
			stow.Link()
			tpm.Install()

			return nil
		},
	}
}
