package install

import (
	"dotfiles/cli/core/env"
	"os"
	"path/filepath"
	"strconv"
	"time"
)

func timestamp() error {
	timestamp := strconv.Itoa(int(time.Now().UnixNano()))

	file := filepath.Join(env.HOME_DIR, "install.timetamp")
	_, err := os.Stat(file)

	if os.IsNotExist(err) {
		fp, err := os.Create(file)

		if err != nil {
			return err
		}

		_, err = fp.WriteString(timestamp)

		if err != nil {
			return err
		}

		env.TIMESTAMP = timestamp
		defer fp.Close()
	}

	return nil
}
