package edit

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/assert"
	"os"

	"github.com/urfave/cli/v3"
)

// dotfiles edit nvim
func Command() *cli.Command {
	return &cli.Command{
		Name:  "edit",
		Usage: "Loads the desired package directory into nvim.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			fmt.Println("BASE:", assert.Must(os.Getwd()))

			return nil
		},
	}
}
