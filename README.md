# Dotfiles (GNU stow)

These dotfiles use the GNU `stow` CLI utility to manage all system configuration files.

## Prerequisites

- [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [stow](https://www.gnu.org/software/stow/)
- [Oh-My-Zsh](https://ohmyz.sh/#install)
- [Powerlevel 10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)

## Setup

These dotfiles are configured to use separate directories for thinking certain things into the system. For example, the `user` directory should only contain user specific configurations, etc.

### Configurations

- `user`
  - **Usage:** `$ stow user`
  - **Description:** Links all the user specific assets to the system.
