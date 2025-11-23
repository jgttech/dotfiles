package main

import (
	"context"
	"jgttech/dotfiles/cmds/git"
	"jgttech/dotfiles/cmds/version"
	"log"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	app := &cli.Command{
		Name:  "dotfiles",
		Usage: "Manages my personal dotfiles",
		Commands: []*cli.Command{
			version.Command,
			git.Command,
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatalln(err)
	}
}
