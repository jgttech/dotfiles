package install

import (
	"context"
	"strconv"
	"time"

	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/exec"
	"dotfiles/cli/core/node"
	"dotfiles/cli/core/tools"
	"fmt"
	"os"
	"path/filepath"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	return &cli.Command{
		Name:    "install",
		Aliases: []string{"i"},
		Usage:   "Detect system and install appropriate dotfiles packages",
		Action: func(ctx context.Context, c *cli.Command) error {
			zshrc, err := node.New(filepath.Join(os.Getenv("HOME"), ".zshrc"))

			if err != nil {
				return err
			}

			if zshrc.Exists() {
				timestamp := strconv.Itoa(int(time.Now().UnixNano()))
				if err = zshrc.Rename(fmt.Sprintf(".zshrc.%s.bak", timestamp)); err != nil {
					return err
				}
			}

			conf, err := dotfiles.Load()

			if err != nil {
				return err
			}

			err = tools.Link()

			if err == nil {
				fmt.Println("Done")
			}

			aqua := conf.GetToolPath("shared/aqua")

			if aqua != "" {
				os.Setenv("AQUA_ROOT_DIR", aqua)
				os.Setenv("AQUA_GLOBAL_CONFIG", filepath.Join(aqua, "aqua.yml"))

				// Install system packages managed by aqua.
				cmd := exec.Cmd("aqua install", exec.Dir(aqua), exec.Stdio)

				if err = cmd.Run(); err != nil {
					return err
				}

				mise := conf.GetToolPath("shared/mise")
				os.Setenv("MISE_DATA_DIR", filepath.Join(mise, "data"))
				os.Setenv("MISE_CACHE_DIR", filepath.Join(mise, "cache"))
				os.Setenv("MISE_GLOBAL_CONFIG_FILE", filepath.Join(mise, "config.toml"))
				os.Setenv("MISE_TMP_DIR", filepath.Join(mise, "tmp"))

				// Install languages managed by mise.
				cmd = exec.Cmd("mise install", exec.Stdio)

				if err = cmd.Run(); err != nil {
					return err
				}
			}

			return err
		},
	}
}
