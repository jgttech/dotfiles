package sys

import (
	"context"
	"os/exec"
	"slices"

	"github.com/urfave/cli/v3"
)

func WithDependencies(dependencies ...string) CommandOption {
	return func(c *cli.Command) {
		original := c.Action

		c.Action = func(ctx context.Context, c *cli.Command) error {
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

			return original(ctx, c)
		}
	}
}
