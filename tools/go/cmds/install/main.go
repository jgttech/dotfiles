package install

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("install")
			return nil
		},
	}
}
