package cfg

const (
	CONFIG_FILENAME = ".dotfiles.build.json"
)

type Build struct {
	CreatedAt int64    `json:"created_at"`
	Version   string   `json:"version"`
	Home      string   `json:"home"`
	Tools     string   `json:"tools"`
	Binary    string   `json:"binary"`
	Zshrc     string   `json:"zshrc"`
	OutDir    string   `json:"out_dir"`
	CliDir    string   `json:"cli_dir"`
	ConfigDir string   `json:"config_dir"`
	BinaryDir string   `json:"binary_dir"`
	Packages  []string `json:"packages"`
}
