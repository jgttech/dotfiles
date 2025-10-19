package save

import (
	"context"
	"dotfiles/cli/core/exec"
	"fmt"
	"os"
	"strings"

	"github.com/urfave/cli/v3"
)

const msg = `
Can you review the current changes in the project
and review what is changed and generate a commit that
summarizes the changes without being too verbose, but
just detailed enough to give another engineer a decent
summary of the changes and then enumerate, in a list,
any important and useful information that another dev
might want to know about the committed changes, please?
Do NOT push the changes, just generate a commit and do
nothing else.
`

func Command() *cli.Command {
	return &cli.Command{
		Name:    "save",
		Aliases: []string{"s"},
		Usage:   "Uses AI to generate a commit from the current changes",
		Action: func(ctx context.Context, c *cli.Command) error {
			cwd, err := os.Getwd()

			if err != nil {
				return err
			}

			argv := []string{
				fmt.Sprintf("claude -p \"%s\"", msg),
				"--permission-mode acceptEdits",
				"--output-format json",
				"--allowedTools \"Bash,Read,Edit,Write\"",
			}

			cmd := exec.Cmd(strings.Join(argv, " "), exec.Stdio, exec.Dir(cwd))
			return cmd.Run()
		},
	}
}
