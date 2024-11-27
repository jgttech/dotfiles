package alacritty

import (
	"fmt"
	"jgttech/dotfiles/env"
	"path"
)

func Swap(name string) {
	base := path.Join(env.BASE, "alacritty", ".config", "alacritty")
	cfg := path.Join(base, "alacritty.toml")
	target := path.Join(base, name)

	fmt.Println("base...:", base)
	fmt.Println("cfg....:", cfg)
	fmt.Println("target.:", target)
}
