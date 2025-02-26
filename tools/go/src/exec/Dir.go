package exec

import "os/exec"

func Dir(dir string) cmdOptions {
	return func(c *exec.Cmd) {
		c.Dir = dir
	}
}
