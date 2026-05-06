#!/usr/bin/env bash
cli="#!/usr/bin/env bash\n"
cli+="source \"$DOTFILES_HOME/cli/main.zsh\"\n"

printf '%b' "$cli" > "$outdir/cli"
chmod +x "$outdir/cli"
