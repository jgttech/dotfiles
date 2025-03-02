package main

import (
	"context"
	"log"
	"os"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/install"
	"jgttech/dotfiles/cmds/purge"
	"jgttech/dotfiles/cmds/version"
	"jgttech/dotfiles/src/cfg"
)

func main() {
	build := cfg.Load()
	app := cli.Command{
		Commands: []*cli.Command{
			install.Command(build),
			version.Command(build),
			purge.Command(build),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}
