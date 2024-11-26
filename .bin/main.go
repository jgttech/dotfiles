package main

import (
	"context"
	"os"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/install"
	"jgttech/dotfiles/cmds/uninstall"
)

func main() {
	app := cli.Command{
		Name: "dotfiles",
		Commands: []*cli.Command{
			install.Command(),
			uninstall.Command(),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		panic(err)
	}
}
