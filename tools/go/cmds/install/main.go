package install

import (
	"context"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "Installs the system packages.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			return nil
		},
	}
}
