package install

import (
	"context"
	"fmt"
	"os"
	"path"
	"runtime"
	"strings"

	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exec"

	"github.com/urfave/cli/v3"
)

// We use this information to do various OS
// specific install processes.
var (
	HOME     = os.Getenv("HOME")
	OS       = strings.ToLower(runtime.GOOS)
	isLinux  = strings.Contains(OS, "linux")
	isDarwin = strings.Contains(OS, "darwin")
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "install",
		Usage: "Installs the system packages.",
		Action: func(ctx context.Context, cmd *cli.Command) error {
			// Do the install work for Alacritty.
			if err := alacritty(build); err != nil {
				return err
			}

			// Do the install work for GhosTTY.
			if err := ghostty(build); err != nil {
				return err
			}

			// Do the install work for setting up the .zshrc config.
			if err := zshrc(build); err != nil {
				return err
			}

			// Link everything in the system.
			return exec.Cmd(
				fmt.Sprintf(
					"stow -t %s %s",
					os.Getenv("HOME"),
					strings.Join(build.Packages, " "),
				),
				exec.Dir(path.Join(build.Home, "packages")),
			).Run()
		},
	}
}
