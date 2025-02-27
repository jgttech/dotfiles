package rebuild

import (
	"context"
	"fmt"

	"jgttech/dotfiles/src/install"

	"github.com/urfave/cli/v3"
)

func Command(build *install.Build) *cli.Command {
	return &cli.Command{
		Name:  "rebuild",
		Usage: "Rebuilds the CLI",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Printf("BUILD: \n%#v\n", build)
			return nil
		},
	}
}
