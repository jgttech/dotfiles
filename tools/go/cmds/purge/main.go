package purge

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/src/cfg"
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "purge",
		Usage: "Unlinks all packages and deletes the dotfiles from the system.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			fmt.Println("Purge")
			return nil
		},
	}
}
