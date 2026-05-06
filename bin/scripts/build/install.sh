#!/usr/bin/env bash
install="#!/usr/bin/env bash\nset -euo pipefail\n"
install+="source \"$DOTFILES_BUILD/environment\"\n"
install+="if [[ -f \"\$HOME/.zshrc\" && ! -L \"\$HOME/.zshrc\" ]]; then\n"
install+="  mv \"\$HOME/.zshrc\" \"$zshrc_backup\"\n"
install+="fi\n"

for ctx in "${contexts[@]}"; do
  dirs=()

  for dir in "${ctx}"/*; do
    dirs+=("$(basename "$dir")")
  done

  (( ${#dirs[@]} == 0 )) && continue

  install+="stow -t \"\$HOME\" -d $(printf '%q' "$ctx") $(printf '%q ' "${dirs[@]}")\n"
done

install+="ln -sf \"$DOTFILES_BUILD/environment\" \"$HOME/.zshrc.environment\"\n"
install+="ln -sf \"$DOTFILES_HOME/devbox.json\" \"$devbox_home/devbox.json\"\n"
install+="devbox global install\n"

printf '%b' "$install" > "$outdir/install"
chmod +x "$outdir/install"
