set export
set quiet

import 'bin/just/clean.just'
import 'bin/just/dotfiles.just'
import 'bin/just/install.just'

default: install
