package cfg

import (
	"encoding/json"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/log"
	"os"
	"path"
)

func (build *Build) Save() {
	file := path.Join(build.ConfigDir, CONFIG_FILENAME)
	data := assert.Must(json.MarshalIndent(build, "", " "))

	if err := os.WriteFile(file, data, 0666); err != nil {
		log.PrintError("Failed to update config file.")
	}
}
