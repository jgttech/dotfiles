package exec

import "os/exec"

func Dir(dir string) option {
	return func(c *exec.Cmd) {
		c.Dir = dir
	}
}
