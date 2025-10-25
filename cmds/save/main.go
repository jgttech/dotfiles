package save

import (
	"context"
	"dotfiles/cli/core/exec"
	"dotfiles/cli/core/tui/spinner"
	"fmt"
	"strings"

	"github.com/urfave/cli/v3"
)

const template = `
Generate a concise, conventional commit message for these changes.

Follow these guidelines:
  - Use conventional commit format (feat:, fix:, docs:, refactor:, etc.)
  - First line should be under 72 characters
  - Be specific and descriptive
  - Focus on the "what" and "why", not the "how"
  - Output ONLY the commit message, no explanations or additional text

Changes:
%s
`

func Command() *cli.Command {
	return &cli.Command{
		Name:  "save",
		Usage: "Utilizes AI to generate a commit",
		Action: func(ctx context.Context, c *cli.Command) error {
			spinner.Start("Creating commit...")
			cmd := exec.Cmd("git add -A")

			if err := cmd.Run(); err != nil {
				spinner.StopWithFailure("Failed to add changes")
				return err
			}

			cmd = exec.Cmd("git diff --staged")
			diff, err := cmd.Output()

			if err != nil {
				spinner.StopWithFailure("Failed to diff changes")
				return err
			}

			if len(strings.TrimSpace(string(diff))) == 0 {
				spinner.StopWithInfo("No changes to commit")
				return nil
			}

			prompt := fmt.Sprintf(template, string(diff))
			cmd = exec.Cmd("claude -p --output-format text")
			cmd.Stdin = strings.NewReader(prompt)

			bytes, err := cmd.Output()

			if err != nil {
				spinner.StopWithFailure("Failed to commit")
				return fmt.Errorf("Failed to create commit message: %w", err)
			}

			message := strings.TrimSpace(string(bytes))

			if message == "" {
				spinner.StopWithFailure("No message to commit")
				return fmt.Errorf("Received empty commit message")
			}

			spinner.StopWithSuccess("Commit created")
			// --- END ---

			fmt.Printf("\nCommit message:\n%s\n\n", message)

			commit := exec.Cmd(
				fmt.Sprintf(
					"git commit -m '%s'",
					strings.ReplaceAll(message, "'", "'\\''"),
				),
				exec.Stdio,
			)

			if err := commit.Run(); err != nil {
				return fmt.Errorf("Failed to create commit: %w", err)
			}

			fmt.Println("✓ Commit created successfully")
			return nil
		},
	}
}
