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

# Development

Development is managed via a `Makefile` using a series of commands found there. But for ease of use, here is what you need to run certain types of operations.

> Regular/Normal Development

With this it copies the repo into the container (not with a volume, by choice) and it runs the installation process in isolation so you can see what happens when the install process is run, without dealing with the `wget` portion of the install process (where the install file is pulled from the repo directly).

```bash
make install
```

> Production Testing

With this approach, the repo is NOT copied into the container, the `wget` approach IS USED and we get to see what a user would see if they attempted to install the dotfiles on their system if it did not have them on it, at all.

```bash
make prod
```

