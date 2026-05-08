#!/usr/bin/env bash
install="#!/usr/bin/env bash\nset -euo pipefail\n"
install+="source \"$DOTFILES_BUILD/environment\"\n\n"
install+="if [[ -f \"\$HOME/.zshrc\" && ! -L \"\$HOME/.zshrc\" ]]; then\n"
install+="  mv \"\$HOME/.zshrc\" \"$zshrc_backup\"\n"
install+="fi\n\n"

for ctx in "${contexts[@]}"; do
  dirs=()

  for dir in "${ctx}"/*; do
    dirs+=("$(basename "$dir")")
  done

  (( ${#dirs[@]} == 0 )) && continue

  install+="stow -t \"\$HOME\" -d $(printf '%q' "$ctx") $(printf '%q ' "${dirs[@]}")\n"
done

install+="\nln -sf \"$DOTFILES_BUILD/environment\" \"\$HOME/.zshrc.environment\"\n"
install+="ln -sf \"$DOTFILES_HOME/devbox.json\" \"$devbox_home/devbox.json\"\n\n"

install+="devbox global install\n\n"

install+="if [[ -f \"$brewfile\" ]]; then\n"
install+="  brew bundle install --file=\"$brewfile\"\n"
install+="fi\n"

printf '%b' "$install" > "$DOTFILES_BUILD/install"
chmod +x "$DOTFILES_BUILD/install"
