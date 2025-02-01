# (WIP) Personal Dotfiles Ecosystem

> WARNING: Do not blindly install scripts you do not trust. First, make sure you trust the source.

These files are my person utilities and implementations that support my own personal goals, desires, and interests. I make no claim about its usefulness to anyone, except myself.

# Prerequisites

Some packages are required to make the system installation work correctly. When installing, if something is missing, the installation script will tell you what is missing. Once you install any missing packges and re-run the script (if you need to) it should just install normally.

1. python
2. git
3. stow
4. wget
5. jq
6. go

## Supported Languages

These dotfiles are centered around the CLI. The CLI can be installed using different supported languages. Unchecked languages are still work-in-progress (wip).

1. [x] Go `(default)`
2. [ ] Python `(wip)`
3. [ ] Odin `(wip)`
4. [ ] Zig `(wip)`
5. [ ] TypeScript `(wip)`

## Quick Setup

This quick setup shows a quick getting started by being able to copy-and-paste commands to get going.

> Arch Linux

```bash
# Installs all the prerequsites and supported languages.
sudo pacman -S git wget jq stow zsh python go odin zig
```

# Installation

By default this uses Python to install the dotfiles, build the CLI, and link the dotfiles to your system. If you just want the default installation, then you only need to concern yourself with the "Default Installation" section. The other sections show how you can change certain aspects of the installation process for customization.

## Default Installation

> Use this if you do not want to change the defaults.

```bash
# By default, this installs into ~/.dotfiles
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python
```

There are a few other ways to install these tools. When installing you can change the:

1. Installation directory.
2. CLI lanaguage.

Below are examples of how to do each of these things.

### Change the installation directory:

```bash
# Adding "- --base=<dir>" you can change what
# directory these dotfiles clone into relative
# to the users HOME directory.
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python - --base=<dir>
```

### Change the CLI language:

```bash
# Adding "- --lang=<lang>" you can change which
# supported language is used for the CLI.
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python - --lang=<lang>
```

### Change both:

```bash
# Using both the "--base" and "--lang" you can
# choose, all at once, where it should install
# to and what language the CLI should use.
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | python - --base=<dir> --lang=<lang>
```

# Development

For some preliminary context, the development of these utils is done with a Podman container to emulate a fresh installation. This may not be exactly perfect, but it is very easy to download a base image and then build an endless surpluss of test images that run the install without affecting your actual system. Plus, I really do not care if Windows works or not. These are only really intended to work on Linux (specifically Arch Linux) and macOS.

All you have to do is clone the repo and run some make commands. That's it. Below is a sample that you can run to make sure everything works. The result of running these commands should be the display of the dotfiles version at the very end.

```bash
# Clone the repo.
git clone git@github.com:jgttech/dotfiles.git

# Ensure we are in the right directory.
cd dotfiles

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
