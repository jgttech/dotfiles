package main

import (
	"context"
	"jgttech/dotfiles/cmds/install"
	"jgttech/dotfiles/cmds/version"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	app := &cli.Command{
		Name:  "dotfiles",
		Usage: "Management CLI for my personal dotfiles",
		Commands: []*cli.Command{
			install.Command,
			version.Command,
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}
