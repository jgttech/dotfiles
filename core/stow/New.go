package stow

import "slices"

// Returns a new pointer to a *Stow reference
// configured based on the builder pattern criteria
// assigned in the options.
func New(options ...Option) *Stow {
	stow := &Stow{}

	for option := range slices.Values(options) {
		option(stow)
	}

	return stow
}
