#!/usr/bin/env bash
# Post-install hook for macOS.
#
# Fonts ship as symlinks placed by stow at ~/Library/Fonts/. macOS's font
# daemon (fontd) auto-discovers files there, but cached font tables in
# already-running apps and in the ATS database don't update until a refresh.
# Clearing the user-level cache here makes the newly-linked fonts visible
# to subsequent app launches without requiring a logout.
echo "Refreshing macOS font caches..."
atsutil databases -remove >/dev/null 2>&1 || true

# If nvm is installed, ensure the latest LTS of NodeJS is installed.
if installed nvm; then
  nvm install --lts && nvm use --lts --default
fi
