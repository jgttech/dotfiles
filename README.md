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
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install.sh" | bash
```

# Development

Development is managed via a `Makefile`. Nothing needs to be run manually.

> Regular/Normal Development

This will run the install process but without the `wget` portion. This is because updates to the GitHub raw content of a file takes time to update and would delay development. So for regular development it is entirely ignored and the install is done via copying the source code into the container the same way the code would be cloned from the install script.

```bash
make dev
```

> Production Testing

This is the same as `make dev` except it does use the GitHub raw content to load the install script from the `wget` command into `bash` and performs the install the exact same way a normal user would use the dotfiles. This is more a way to test the actuall install process, the exact same way a user would.

```bash
make prod
```
