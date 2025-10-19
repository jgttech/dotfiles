package stow

func WithDirectory(directory string) Option {
	return func(s *Stow) {
		s.directory = directory
	}
}
