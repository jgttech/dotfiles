set export
set quiet

import 'bin/just/dotfiles.just'
import 'bin/just/install.just'

default: install
