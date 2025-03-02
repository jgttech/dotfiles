package purge

import (
	"context"
	"fmt"
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exec"
	"os"
	"path"

	"github.com/urfave/cli/v3"
)

var (
	HOME = os.Getenv("HOME")
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "purge",
		Usage: "Completely removes the dotfiles and CLI from the system, entirely.",
		Action: func(ctx context.Context, c *cli.Command) error {
			cwd := path.Join(build.Home, build.OutDir)

			uninstall := exec.Cmd("dotfiles uninstall", exec.Stdio)
			unlinkCli := exec.Cmd(fmt.Sprintf("stow -t %s -D cli", build.BinaryDir), exec.Dir(cwd))
			unlinkConfig := exec.Cmd(fmt.Sprintf("stow -t %s -D config", HOME), exec.Dir(cwd))

			if err := uninstall.Run(); err != nil {
				return err
			}

			if err := unlinkCli.Run(); err != nil {
				return err
			}

			if err := unlinkConfig.Run(); err != nil {
				return err
			}

			if err := os.RemoveAll(build.Home); err != nil {
				return err
			}

			return nil
		},
	}
}
