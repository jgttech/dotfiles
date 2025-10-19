package stow

import "slices"

// Adds a packages to the *Stow instance.
func (stow *Stow) Add(pkg string) {
	if !slices.Contains(stow.packages, pkg) {
		stow.packages = append(stow.packages, pkg)
	}
}
