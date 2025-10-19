package stow

type Option func(*Stow)
type List []*Stow

type Stow struct {
	packages  []string
	directory string
	target    string
	replace   bool
	delete    bool
}
