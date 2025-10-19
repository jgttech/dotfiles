package sys

import (
	"slices"

	"github.com/urfave/cli/v3"
)

type CommandOption func(*cli.Command)

func NewCommand(origin *cli.Command, options ...CommandOption) *cli.Command {
	for option := range slices.Values(options) {
		option(origin)
	}

	return origin
}
