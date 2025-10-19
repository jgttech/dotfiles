package stow

func (stow *Stow) IsValid() bool {
	return len(stow.packages) > 0
}
