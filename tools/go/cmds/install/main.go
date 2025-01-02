package install

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/assert"
	"os"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "",
		Action: func(ctx context.Context, c *cli.Command) error {
			wd := assert.Must(os.Getwd())

			fmt.Println("cwd:", wd)
			return nil
		},
	}
}
