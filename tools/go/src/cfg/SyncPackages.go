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

	if !update {
		// Check if any of the build config packages are
		// missing from the detected packages.
		for pkg := range slices.Values(build.Packages) {
			if !slices.Contains(packages, pkg) {
				update = true
				break
			}
		}

		// Check if any of the detected packages are missing
		// from the build config packages.
		for pkg := range slices.Values(packages) {
			if !slices.Contains(build.Packages, pkg) {
				update = true
				break
			}
		}
	}

	if update {
		build.Packages = packages
		build.Save()
	}
}
