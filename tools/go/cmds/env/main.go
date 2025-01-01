package env

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "env",
		Usage: "",
		Action: func(ctx context.Context, c *cli.Command) error {
			fmt.Println("ENV")
			return nil
		},
	}
}
