package version

import (
	"context"
	"fmt"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/src/cfg"
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "version",
		Usage: "Displays the version from the CLI build JSON file.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			fmt.Println(fmt.Sprintf("%s %s", build.Binary, build.Version))
			return nil
		},
	}
}
