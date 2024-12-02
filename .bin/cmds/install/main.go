package install

import (
	"context"
	"jgttech/dotfiles/src/pkg/alacritty"
	"jgttech/dotfiles/src/pkg/stow"
	"jgttech/dotfiles/src/pkg/tpm"

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
