package main

import (
	"context"
	"dotfiles/cli/cmds/install"
	"dotfiles/cli/cmds/save"
	"dotfiles/cli/cmds/uninstall"
	"dotfiles/cli/core/sys"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	app := &cli.Command{
		Name:  "dotfiles",
		Usage: "Dotfiles CLI manager for my personal dotfiles",
		Before: func(ctx context.Context, c *cli.Command) (context.Context, error) {
			return ctx, nil
		},
		Commands: []*cli.Command{
			sys.NewCommand(
				install.Command(),
				sys.WithDependencies("stow"),
			),
			sys.NewCommand(
				uninstall.Command(),
				sys.WithDependencies("stow"),
			),
			sys.NewCommand(
				save.Command(),
				sys.WithDependencies("claude"),
			),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatalln(err)
	}
}
