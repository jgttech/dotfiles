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

const (
	CONFIG_FILENAME = ".dotfiles.build.json"
)

type Build struct {
	CreatedAt int64    `json:"created_at"`
	Version   string   `json:"version"`
	Home      string   `json:"home"`
	Tools     string   `json:"tools"`
	Binary    string   `json:"binary"`
	Zshrc     string   `json:"zshrc"`
	OutDir    string   `json:"out_dir"`
	CliDir    string   `json:"cli_dir"`
	ConfigDir string   `json:"config_dir"`
	BinaryDir string   `json:"binary_dir"`
	Packages  []string `json:"packages"`
}

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

	return build
}
