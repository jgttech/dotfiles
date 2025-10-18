package install

import (
	"context"
	"dotfiles/cli/core/env"
	"dotfiles/cli/core/pkg"
	"dotfiles/cli/core/tools"
	"fmt"
	"slices"
	"strings"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "Install a particular type of dotfiles",
		Action: func(ctx context.Context, c *cli.Command) error {
			if err := pkg.Required("stow"); err != nil {
				return err
			}

			nodes, err := tools.Detect()

			if err != nil {
				return err
			}

			for node := range slices.Values(nodes) {
				x := strings.Split(node.Source(), env.HOME_TOOLS)
				fmt.Println(x)
			}

			return nil
		},
	}
}
