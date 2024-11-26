# Dotfiles

My personal dotfiles.

## Prerequisites

- [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  - The shell of my choice.
- [Oh My ZSH](https://ohmyz.sh/#install)
  - For themeing the terminal.
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - For themeing the terminal.
- [Homebrew](https://brew.sh/)
  - Used to install some kinds of packages.

## Automatic Installation & Setup

```bash
URL="https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/.bin/install" wget -qO- $URL | bash
```

## Getting Started

> Clone the repo to wherever you want, I use `dotfiles`.

```bash
gh repo clone jgttech/dotfiles
```

> Link all the things.

```bash
cd ~/dotfiles
stow alacritty nvim p10k tmux zsh
cd ~
```

### Yolo

```bash
gh repo clone jgttech/dotfiles; cd ~/dotfiles; stow alacritty nvim p10k tmux zsh; cd ~; exit;
```
