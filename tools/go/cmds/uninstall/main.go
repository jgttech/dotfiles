package uninstall

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "uninstall",
		Usage: "",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("uninstall")
			return nil
		},
	}
}
