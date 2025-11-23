set export
set quiet

import "bin/just/add.just"
import "bin/just/install.just"
import "bin/just/release.just"
import "bin/just/save.just"

default: install
