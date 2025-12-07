package install

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
)

var Command = &cli.Command{
	Name: "install",
	Action: func(ctx context.Context, c *cli.Command) error {
		fmt.Printf("INSTALL")
		return nil
	},
}
