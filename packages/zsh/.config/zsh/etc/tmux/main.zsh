#!/usr/bin/env zsh
function tsession {
  tmux new-session -s "$1"
}
