package main

import (
	"context"
	"os"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/env"
	"jgttech/dotfiles/cmds/install"
	"jgttech/dotfiles/cmds/purge"
	"jgttech/dotfiles/cmds/uninstall"
)

func main() {
	app := &cli.Command{
		Name:  "dotfiles",
		Usage: "My personal dotfiles CLI.",
		Commands: []*cli.Command{
			env.Command(),
			install.Command(),
			purge.Command(),
			uninstall.Command(),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		panic(err)
	}
}
