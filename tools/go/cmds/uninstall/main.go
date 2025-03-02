package uninstall

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exec"
	"os"
	"path"
	"strings"

	"github.com/urfave/cli/v3"
)

var (
	HOME = os.Getenv("HOME")
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "uninstall",
		Usage: "Removes the system packages and resets the ZSHRC file. Does NOT uninstall the CLI.",
		Action: func(ctx context.Context, c *cli.Command) error {
			packages := strings.Join(build.Packages, " ")
			packagesDir := path.Join(build.Home, "packages")
			stow := exec.Cmd(
				fmt.Sprintf("stow -t %s -D %s", HOME, packages),
				exec.Dir(packagesDir),
			)

			if err := stow.Run(); err != nil {
				return err
			}

			// Resets the ZSHRC config from the backup that was created.
			zshrc()

			return nil
		},
	}
}
