package edit

import (
	"context"
	"dotfiles/cli/core/dotfiles"
	"dotfiles/cli/core/exec"
	"dotfiles/cli/core/tui/theme"
	"errors"
	"fmt"

	"github.com/urfave/cli/v3"
)

func Command() *cli.Command {
	var list, path bool

	return &cli.Command{
		Name:    "edit",
		Aliases: []string{"e"},
		Usage:   "Opens IDE in that tools home path",
		Flags: []cli.Flag{
			&cli.BoolFlag{
				Name:        "list",
				Aliases:     []string{"l"},
				Usage:       "List all available tools",
				Destination: &list,
			},
			&cli.BoolFlag{
				Name:        "path",
				Aliases:     []string{"p"},
				Usage:       "Return the system path to the tool",
				Destination: &path,
			},
		},
		Action: func(ctx context.Context, c *cli.Command) error {
			name := c.Args().First()
			conf, err := dotfiles.Load()

			if list {
				for key := range conf.Tools {
					fmt.Printf(
						"%s %s\n",
						theme.
							Info.
							UnsetBackground().
							Render(theme.RIGHT_ARROW_ICON),
						key,
					)
				}

				return nil
			}

			if err != nil {
				return err
			}

			if name == "" {
				return errors.New("An argument is required")
			}

			dir := conf.GetToolDir(name)

			if dir == "" {
				return errors.New("Invalid tool name")
			}

			if !path {
				cmd := exec.Cmd("nvim .", exec.Dir(dir), exec.Stdio)
				return cmd.Run()
			}

			fmt.Println(conf.GetToolPath(name))
			return nil
		},
	}
}
