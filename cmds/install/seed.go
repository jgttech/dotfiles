package install

import (
	"crypto/md5"
	"dotfiles/cli/core/env"
	"encoding/hex"
	"os"
	"strconv"
	"time"
)

func seed() error {
	timestamp := strconv.Itoa(int(time.Now().UnixNano()))

	hasher := md5.New()
	hasher.Write([]byte(timestamp))
	bytes := hasher.Sum(nil)
	seed := hex.EncodeToString(bytes)

	_, err := os.Stat(env.HOME_SEED)

	if os.IsNotExist(err) {
		fp, err := os.Create(env.HOME_SEED)

		if err != nil {
			return err
		}

		_, err = fp.WriteString(seed)

		if err != nil {
			return err
		}

		env.SEED = seed
		defer fp.Close()
	}

	return nil
}
