package owner

import (
	"context"
	"jgttech/dotfiles/src/cfg"
	"jgttech/dotfiles/src/exceptions"
	"jgttech/dotfiles/src/exec"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"

	"github.com/urfave/cli/v3"
)

func Command(build *cfg.Build) *cli.Command {
	return &cli.Command{
		Name:  "owner",
		Usage: "Replaces the .git directory with one from the actual owner.",
		Action: func(ctx context.Context, c *cli.Command) error {
			clone := exec.Cmd("gh repo clone jgttech/dotfiles .tmp", exec.Stdio, exec.Dir(build.Home))

			if err := clone.Run(); err != nil {
				return err
			}

			tmpRepo := path.Join(build.Home, ".tmp")

			if !_os.Exists(tmpRepo) {
				return exceptions.FileNotFound(".tmp")
			}

			gitPath := path.Join(build.Home, ".git")
			tmpPath := path.Join(tmpRepo, ".git")

			if err := os.RemoveAll(gitPath); err != nil {
				return err
			}

			if err := os.CopyFS(gitPath, os.DirFS(tmpPath)); err != nil {
				return err
			}

			if err := os.RemoveAll(tmpRepo); err != nil {
				return err
			}

			return nil
		},
	}
}
