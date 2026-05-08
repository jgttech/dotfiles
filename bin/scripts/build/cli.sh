#!/usr/bin/env bash
cli="#!/usr/bin/env bash\n"
cli+="source \"$DOTFILES_HOME/cli/main.zsh\"\n"

printf '%b' "$cli" > "$DOTFILES_BUILD/cli"
chmod +x "$DOTFILES_BUILD/cli"
