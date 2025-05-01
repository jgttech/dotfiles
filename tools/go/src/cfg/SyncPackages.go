package cfg

import (
	"jgttech/dotfiles/src/assert"
	_os "jgttech/dotfiles/src/os"
	"os"
	"path"
	"slices"
	"strings"
)

func (build *Build) SyncPackages() {
	update := false
	dir := path.Join(build.Home, "packages")
	entries := assert.Must(os.ReadDir(dir))
	packages := []string{}
	// missing := []string{}

	for pkg := range slices.Values(entries) {
		name := pkg.Name()
		skip := false

		for platform := range slices.Values(_os.PLATFORMS) {
			if strings.Contains(name, platform) {
				skip = true

				if strings.Contains(name, _os.UNAME) {
					packages = append(packages, name)
					break
				}
			}
		}

		if !skip {
			packages = append(packages, name)
		}
	}

	if len(packages) > 0 {
		for pkg := range slices.Values(build.Packages) {
			if !slices.Contains(packages, pkg) {
				idx := slices.Index(build.Packages, pkg)
				build.Packages = slices.Delete(build.Packages, idx, idx+1)

				if !update {
					update = true
				}
			}
		}

		if update {
			build.Packages = packages
			build.Save()
		}
	}
}
