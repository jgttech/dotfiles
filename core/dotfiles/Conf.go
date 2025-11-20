package dotfiles

type Conf struct {
	Tools map[string]string `yaml:"tools"`
	Npm   []string          `yaml:"npm"`
}
