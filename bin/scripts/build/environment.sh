#!/usr/bin/env bash
environ="#!/usr/bin/env bash\n"
environ+="export DOTFILES_HOME=\"$DOTFILES_HOME\"\n"
environ+="export DOTFILES_CONFIG=\"$DOTFILES_CONFIG\"\n"
environ+="export DOTFILES_BUILD=\"$DOTFILES_BUILD\"\n"
environ+="export DOTFILES_VERSION=\"$DOTFILES_VERSION\"\n"

printf '%b' "$environ" > "$DOTFILES_BUILD/environment"
chmod +x "$DOTFILES_BUILD/environment"
