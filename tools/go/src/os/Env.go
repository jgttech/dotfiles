package os

import (
	"runtime"
	"strings"
)

var (
	UNAME     = strings.ToLower(runtime.GOOS)
	IS_LINUX  = strings.Contains(UNAME, "linux")
	IS_DARWIN = strings.Contains(UNAME, "darwin")
	PLATFORMS = []string{"linux", "darwin"}
)
