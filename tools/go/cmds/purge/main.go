package purge

import (
	"context"

	"github.com/urfave/cli/v3"
	// "jgttech/dotfiles/src/exec"
	"jgttech/dotfiles/src/install"
)

func Command(build *install.Build) *cli.Command {
	return &cli.Command{
		Name:        "purge",
		Description: "Invokes the Python purge script.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			// sh := exec.Cmd("bash bin/purge.sh", exec.Stdio)
			// sh.Dir = ""

			return nil
		},
	}
}
