package main

import (
	"context"
	"os"

	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/env"
)

func main() {
	app := &cli.Command{
		Name: "dotfiles",
		Commands: []*cli.Command{
			env.Command(),
		},
	}

	if err := app.Run(context.Background(), os.Args); err != nil {
		panic(err)
	}
}
