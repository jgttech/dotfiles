package stow

func WithTarget(target string) Option {
	return func(s *Stow) {
		s.target = target
	}
}
