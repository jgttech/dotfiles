set export
set quiet

import "bin/just/add.just"
import "bin/just/clean.just"
import "bin/just/connect.just"
import "bin/just/dotfiles.just"
import "bin/just/exec.just"
import "bin/just/go.just"
import "bin/just/install.just"
import "bin/just/run.just"
import "bin/just/runtime.just"
import "bin/just/save.just"

default: install
