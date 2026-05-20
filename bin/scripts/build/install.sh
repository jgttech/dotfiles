#!/usr/bin/env bash
install="#!/usr/bin/env bash\nset -euo pipefail\n"
install+="source \"$DOTFILES_BUILD/environment\"\n\n"

for rel in "${backups[@]}"; do
  install+="if [[ -e \"\$HOME/$rel\" && ! -L \"\$HOME/$rel\" ]]; then\n"
  install+="  mv \"\$HOME/$rel\" \"\$HOME/$rel.$ts.bak\"\n"
  install+="fi\n\n"
done

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

install+="devbox global install\n"
install+="stat -c '%Y:%s' \"$devbox_home/devbox.json\" \"$devbox_home/devbox.lock\" > \"$DOTFILES_HOME/devbox.fingerprint\"\n\n"

install+="if [[ -f \"$brewfile\" ]]; then\n"
install+="  brew bundle install --file=\"$brewfile\"\n"
install+="  _brewfp_paths=()\n"
install+="  for _d in Cellar Caskroom Library/Taps; do\n"
install+="    [[ -e \"\$(brew --prefix)/\$_d\" ]] && _brewfp_paths+=(\"\$(brew --prefix)/\$_d\")\n"
install+="  done\n"
install+="  (( \${#_brewfp_paths[@]} )) && stat -c '%Y:%s' \"\${_brewfp_paths[@]}\" > \"\$HOME/.config/brew/Brewfile.fingerprint\"\n"
install+="  unset _brewfp_paths _d\n"
install+="fi\n\n"

# Register the local marketplace and install the dotfiles plugin for Claude Code.
# Idempotent: skips both if state files already declare them. claude itself is
# not idempotent on re-install (creates duplicate scope entries), so guard with
# yq before invoking.
install+="if command -v claude >/dev/null 2>&1; then\n"
install+="  _plugins_state=\"\$HOME/.claude/plugins/installed_plugins.json\"\n"
install+="  _marketplaces_state=\"\$HOME/.claude/plugins/known_marketplaces.json\"\n"
install+="  if ! [[ -f \"\$_marketplaces_state\" ]] || ! yq -e '.local' \"\$_marketplaces_state\" >/dev/null 2>&1; then\n"
install+="    claude plugin marketplace add $(printf '%q' "$DOTFILES_HOME/os/shared/claude/.claude/plugins/local")\n"
install+="  fi\n"
install+="  if ! [[ -f \"\$_plugins_state\" ]] || ! yq -e '.plugins[\"dotfiles@local\"][]? | select(.scope == \"user\")' \"\$_plugins_state\" >/dev/null 2>&1; then\n"
install+="    claude plugin install dotfiles@local --scope user\n"
install+="  fi\n"
install+="  unset _plugins_state _marketplaces_state\n"
install+="fi\n\n"

# OS-specific post-install finalization (font caches on darwin, etc.).
# Uses the `script` helper (sourced via bootstrap.sh) so dispatch runs in
# the enclosing devbox bash — no nested `devbox run`, no cwd dependence.
install+="script post-install\n"

printf '%b' "$install" > "$DOTFILES_BUILD/install"
chmod +x "$DOTFILES_BUILD/install"
