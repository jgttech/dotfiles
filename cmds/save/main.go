package save

import (
	"context"
	"dotfiles/cli/core/exec"
	"fmt"
	"os"
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
			cmd := exec.Cmd("git add -A")

			if err := cmd.Run(); err != nil {
				return err
			}

			cmd = exec.Cmd("git diff --staged")
			diff, err := cmd.Output()

			if err != nil {
				return err
			}

			if len(strings.TrimSpace(string(diff))) == 0 {
				fmt.Println("No changes to commit")
				return nil
			}

			prompt := fmt.Sprintf(template, string(diff))
			cmd = exec.Cmd("claude -p --output-format text")
			cmd.Stdin = strings.NewReader(prompt)

			bytes, err := cmd.Output()

			if err != nil {
				return fmt.Errorf("Failed to generate commit message: %w", err)
			}

			message := strings.TrimSpace(string(bytes))

			if message == "" {
				return fmt.Errorf("Received empty commit message")
			}

			fmt.Printf("\nCommit message:\n%s\n\n", message)

			commit := exec.Cmd(
				fmt.Sprintf(
					"git commit -m '%s'",
					strings.ReplaceAll(message, "'", "'\\''"),
				),
			)

			commit.Stdout = os.Stdout
			commit.Stderr = os.Stderr

			if err := commit.Run(); err != nil {
				return fmt.Errorf("Failed to create commit: %w", err)
			}

			fmt.Println("✓ Commit created successfully")
			return nil
		},
		// 		Action: func(ctx context.Context, c *cli.Command) error {
		// 			// Stage all changes
		// 			fmt.Println("Staging all changes...")
		// 			stageCmd := exec.Cmd("git add -A")
		// 			if err := stageCmd.Run(); err != nil {
		// 				return fmt.Errorf("failed to stage changes: %w", err)
		// 			}
		//
		// 			// Get staged diff
		// 			diffCmd := exec.Cmd("git diff --staged")
		// 			diffOutput, err := diffCmd.Output()
		// 			if err != nil {
		// 				return fmt.Errorf("failed to get diff: %w", err)
		// 			}
		//
		// 			// Check if there are any changes
		// 			if len(strings.TrimSpace(string(diffOutput))) == 0 {
		// 				fmt.Println("No changes to commit")
		// 				return nil
		// 			}
		//
		// 			// Generate commit message using Claude
		// 			fmt.Println("Generating commit message with AI...")
		// 			prompt := fmt.Sprintf(`Generate a concise, conventional commit message for these changes.
		// Follow these guidelines:
		// - Use conventional commit format (feat:, fix:, docs:, refactor:, etc.)
		// - First line should be under 72 characters
		// - Be specific and descriptive
		// - Focus on the "what" and "why", not the "how"
		// - Output ONLY the commit message, no explanations or additional text
		//
		// Changes:
		// %s`, string(diffOutput))
		//
		// 			claudeCmd := exec.Cmd("claude -p --output-format text")
		// 			claudeCmd.Stdin = strings.NewReader(prompt)
		// 			commitMsg, err := claudeCmd.Output()
		// 			if err != nil {
		// 				return fmt.Errorf("failed to generate commit message: %w", err)
		// 			}
		//
		// 			message := strings.TrimSpace(string(commitMsg))
		// 			if message == "" {
		// 				return fmt.Errorf("received empty commit message from Claude")
		// 			}
		//
		// 			fmt.Printf("\nCommit message:\n%s\n\n", message)
		//
		// 			// Create the commit
		// 			fmt.Println("Creating commit...")
		// 			commitCmd := exec.Cmd(fmt.Sprintf("git commit -m '%s'",
		// 				strings.ReplaceAll(message, "'", "'\\''")))
		// 			commitCmd.Stdout = os.Stdout
		// 			commitCmd.Stderr = os.Stderr
		// 			if err := commitCmd.Run(); err != nil {
		// 				return fmt.Errorf("failed to create commit: %w", err)
		// 			}
		//
		// 			fmt.Println("✓ Commit created successfully")
		// 			return nil
		// 		},
	}
}
