set export
set quiet

import 'bin/just/clean.just'
import 'bin/just/dotfiles.just'
import 'bin/just/exec.just'
import 'bin/just/install.just'
import 'bin/just/reload.just'
import 'bin/just/run.just'
import 'bin/just/runtime.just'

default: install
