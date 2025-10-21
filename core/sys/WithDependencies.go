package sys

import (
	"context"
	"os/exec"
	"slices"

	"github.com/urfave/cli/v3"
)

const skipFlag = "skip-dependency-check"

func WithDependencies(dependencies ...string) CommandOption {
	return func(c *cli.Command) {
		var skip bool
		skipBoolFlag := &cli.BoolFlag{
			Name:        skipFlag,
			Value:       skip,
			Destination: &skip,
		}

		original := c.Action
		flags := c.Flags

		if len(flags) > 0 {
			for idx, flag := range flags {
				if slices.Contains(flag.Names(), skipFlag) {
					flags[idx] = skipBoolFlag
					break
				}
			}
		} else {
			c.Flags = []cli.Flag{
				skipBoolFlag,
			}
		}

		c.Action = func(ctx context.Context, c *cli.Command) error {
			if !skip {
				missing := []string{}

				for dep := range slices.Values(dependencies) {
					_, err := exec.LookPath(dep)

					if err != nil {
						missing = append(missing, dep)
					}
				}

				if len(missing) > 0 {
					return MissingDependencies(missing)
				}
			}

			return original(ctx, c)
		}
	}
}
