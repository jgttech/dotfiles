package stow

import "slices"

func WithPackages(packages []string) Option {
	return func(s *Stow) {
		for pkg := range slices.Values(packages) {
			if !slices.Contains(s.packages, pkg) {
				s.packages = append(s.packages, pkg)
			}
		}
	}
}
