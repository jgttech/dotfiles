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

```bash
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/.bin/scripts/install" | bash
```

## Uninstall

There are 2 types of uninstall; 1 - removes the symlinks and 2 - remove the symlinks and delete the `dotfiles` repo. Pick one of these options. Choose wisely.

> 1. Only remove the symlinks

```bash
dotfiles uninstall
```

> 2. Remove the symlinks AND delete the repo, locally.

```bash
dotfiles uninstall --destroy
```

## Re-install

If you uninstalled ONLY the symlinks using `dotfiles uninstall` you can re-link everything back-up with the following command.

```bash
dotfiles install
```
