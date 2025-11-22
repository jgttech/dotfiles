set export
set quiet

import "bin/just/add.just"
import "bin/just/install.just"

default: install
