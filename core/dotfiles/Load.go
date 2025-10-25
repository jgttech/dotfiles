package dotfiles

import (
	"dotfiles/cli/core/env"
	"os"

	"github.com/goccy/go-yaml"
)

func Load() (*Dotfiles, error) {
	conf := &Dotfiles{}
	bytes, err := os.ReadFile(env.DOTFILES_YAML)

	if err != nil {
		return conf, err
	}

	if err = yaml.Unmarshal(bytes, conf); err != nil {
		return conf, err
	}

	return conf, nil
}
