package git

import (
	"github.com/urfave/cli/v3"
	"jgttech/dotfiles/cmds/git/save"
)

var Command = &cli.Command{
	Name:  "git",
	Usage: "Dotfiles utilities for git",
	Commands: []*cli.Command{
		save.Command,
	},
}
