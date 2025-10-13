package main

import (
	"context"
	"dotfiles/cli/cmds/install"
	"dotfiles/cli/cmds/version"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	app := &cli.Command{
		Name:  "dotfiles",
		Usage: "Dotfiles CLI manager for my personal dotfiles",
		Commands: []*cli.Command{
			version.Command(),
			install.Command(),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatalln(err)
	}
}
