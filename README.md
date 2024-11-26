# Dotfiles

My personal dotfiles.

## Prerequisites

- [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  - Need to install and configure a setup before installing the dotfiles.
- [Oh My ZSH](https://ohmyz.sh/#install)
  - Could set this up, if desired.
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
  - Could set this up, if desired.

## Getting Started

> Clone the repo to wherever you want, I use `dotfiles`.

```bash
gh repo clone jgttech/dotfiles
```

> Link all the things.

```bash
cd ~/dotfiles; stow alacritty nvim omz p10k tmux zsh; cd ~;
```
