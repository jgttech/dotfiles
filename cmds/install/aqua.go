package install

import (
	"dotfiles/cli/core/exec"
	"os"
	"path/filepath"
)

func aqua(dir string) error {
	os.Setenv("AQUA_ROOT_DIR", dir)
	os.Setenv("AQUA_GLOBAL_CONFIG", filepath.Join(dir, "aquaDir.yml"))

	// Install system packages managed by aquaDir.
	cmd := exec.Cmd("aqua install", exec.Dir(dir), exec.Stdio)

	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
