package install

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "install",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("INSTALLING!!!!")
			return nil
		},
	}
}
