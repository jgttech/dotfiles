package main

import (
	"context"
	"log"
	"os"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/purge"
	"jgttech/dotfiles/cmds/version"
	"jgttech/dotfiles/src/install"
)

func main() {
	build := install.LoadBuild()

	app := cli.Command{
		Name: "dotfiles",
		Commands: []*cli.Command{
			version.Command(build),
			purge.Command(build),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}
