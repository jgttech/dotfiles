package install

import (
	"dotfiles/cli/core/exec"
	"os"
	"path/filepath"
)

func mise(dir string) error {
	os.Setenv("MISE_DATA_DIR", filepath.Join(dir, "data"))
	os.Setenv("MISE_CACHE_DIR", filepath.Join(dir, "cache"))
	os.Setenv("MISE_GLOBAL_CONFIG_FILE", filepath.Join(dir, "config.toml"))
	os.Setenv("MISE_TMP_DIR", filepath.Join(dir, "tmp"))

	// Install languages managed by mise.
	cmd := exec.Cmd("mise install", exec.Stdio)

	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
