package install

import (
	"encoding/json"
	"io"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/exceptions"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"
)

type Build struct {
	CreatedAt string   `json:"created_at"`
	Home      string   `json:"home"`
	Tools     string   `json:"tools"`
	Binary    string   `json:"binary"`
	Where     string   `json:"where"`
	Version   string   `json:"version"`
	Zshrc     string   `json:"zshrc"`
	Cli       string   `json:"cli"`
	Packages  []string `json:"packages"`
}

func LoadBuild() *Build {
	cfgName := ".dotfiles.build.json"
	cfgFile := path.Join(os.Getenv("HOME"), cfgName)

	if !_os.Exists(cfgFile) {
		panic(exceptions.FileNotFound(cfgName))
	}

	file := assert.Must(os.Open(cfgFile))
	defer file.Close()

	bytes := assert.Must(io.ReadAll(file))
	build := &Build{}

	json.Unmarshal([]byte(bytes), build)

	return build
}
