#!/usr/bin/env bash
# Post-uninstall hook for macOS.
#
# Stow's -D pass removed the font symlinks from ~/Library/Fonts/, but the
# ATS font database and already-running apps still cache the entries. Clear
# the user-level cache here so the removed fonts disappear from subsequent
# app launches without requiring a logout.
echo "Refreshing macOS font caches..."
atsutil databases -remove >/dev/null 2>&1 || true
