package uninstall

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "uninstall",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("UNINSTALLING!!!!!!!!!!")
			return nil
		},
	}
}
