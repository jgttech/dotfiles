# Dotfiles

My personal dotfiles.

## Packges

- [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  - The shell of my choice.
- [Oh My ZSH](https://ohmyz.sh/#install)
  - For themeing the terminal.
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - For themeing the terminal.
- [Homebrew](https://brew.sh/)
  - Used to install some kinds of packages.

## Install

This is intended for installation from scratch. This will attempt to install the Prerequisites, build the Go binary for installation and run it.

```bash
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/.bin/scripts/install" | bash
```

## Uninstall

There are 2 types of uninstall; 1 - removes the symlinks and 2 - remove the symlinks and delete the `dotfiles` repo. Choose wisely.

> Only remove the symlinks

```bash
dotfiles uninstall
```

> Remove the symlinks AND delete the repo, locally.

```bash
dotfiles uninstall --destroy
```
