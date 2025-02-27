# (WIP) Personal Dotfiles Ecosystem

> WARNING: Do not blindly install scripts you do not trust. First, make sure you trust the source.

These files are my person utilities and implementations that support my own personal goals, desires, and interests. I make no claim about its usefulness to anyone, except myself.

## Setup

This quick setup shows a quick getting started by being able to copy-and-paste commands to get going.

> Arch Linux

```bash
# Installs all the prerequsites and supported languages.
sudo pacman -S git wget jq stow zsh python go odin zig unzip zip getopt fontconfig base-devel
```

# Installation

```bash
# By default, this installs into ~/.dotfiles
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles.v2/refs/heads/main/bin/install.sh" | bash
```
