package cfg

import (
	"encoding/json"
	"io"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/exceptions"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"
	"time"
)

func Load() *Build {
	build := &Build{}
	build.CreatedAt = time.Now().Unix()

	cfgFile := path.Join(os.Getenv("HOME"), CONFIG_FILENAME)

	if !_os.Exists(cfgFile) {
		panic(exceptions.FileNotFound(cfgFile))
	}

	file := assert.Must(os.Open(cfgFile))
	defer file.Close()

	bytes := assert.Must(io.ReadAll(file))
	json.Unmarshal([]byte(bytes), build)

	build.SyncPackages()

	return build
}
