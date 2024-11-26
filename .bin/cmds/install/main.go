package install

import (
	"context"
	"fmt"
	"jgttech/dotfiles/assert"
	"jgttech/dotfiles/env"
	"os"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name: "install",
		Action: func(ctx context.Context, c *cli.Command) error {
			for _, file := range assert.Must(os.ReadDir(env.BASE)) {
				fmt.Println(file.Name())
			}

			return nil
		},
	}
}
