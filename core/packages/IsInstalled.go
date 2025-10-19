package packages

import "os/exec"

func IsInstalled(name string) bool {
	_, err := exec.LookPath(name)
	return err == nil
}
