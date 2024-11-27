package install

import (
	"context"
	"fmt"
	"jgttech/dotfiles/alacritty"
	"jgttech/dotfiles/stow"
	"runtime"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "install",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("goos:", runtime.GOOS)

			if runtime.GOOS == "darwin" {
				alacritty.Swap("alacritty.darwin.toml")
			} else if runtime.GOOS == "linux" {
				alacritty.Swap("alacritty.linux.toml")
			}

			stow.Link()

			return nil
		},
	}
}
