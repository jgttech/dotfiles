# Personal Dotfiles Ecosystem

These files are my person utilities and implementations that support my own personal goals, desires, and interests. I make no claim about its usefulness to anyone, except myself.

# Prerequisites

Some packages are required to make the system installation work correctly.

1. Python
  - For running the install script
2. Git
3. GNU Stow
4. wget
5. jq
6. (depends) Go lang
  - This is the default dotfiles CLI language.

## Quick Setup

> Arch Linux

```bash
# Installs all the prerequsites and supported languages.
sudo pacman -S git wget jq stow zsh python go odin zig
```

# Installation

> WARNING: Do not blindly install scripts you do not trust. First, make sure you trust the source.

```bash
# By default, this installs in to ~/.dotfiles
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python
```

## Change the Installation Location

```bash
# Adding "- --base=<dir>" you can change what
# directory these dotfiles clone into relative
# to the users HOME directory.
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python - --base=<dir>
```

# Development

For some preliminary context, the development of these utils is done with a Podman container to emulate a fresh installation. This may not be exactly perfect, but it is very easy to download a base image and then build an endless surpluss of test images that run the install without affecting your actual system. Plus, I really do not care if Windows works or not. These are only really intended to work on Linux (specifically Arch Linux) and macOS.

All you have to do is clone the repo and run some make commands. That's it. Below is a sample that you can run to make sure everything works. The result of running these commands should be the display of the dotfiles version at the very end.

```bash
# Clone the repo.
git clone git@github.com:jgttech/dotfiles.v2.git

# Test it to make sure it works.
make version
```

## Development Commands

You can review the `Makefile` to see for yourself, but here is a quick breakdown of what I can do with the `Makefile`:

| Command | Description |
|:-|:-|
| `make install` | Removes any existing container and images. Then it rebuilds and runs the installation in a fresh container. |
| `make version` | Does the same things as `make install` but, at the end, uses `jq` to print the CLI version. |
| `make build` | Removes any existing image and builds/rebuilds a new one. |
| `make rmi` | If an image already exits, it removes it. |
| `make rm` | If a container already exists, it kills it and removes it. |
