# Dotfiles (GNU stow)

These dotfiles use the GNU `stow` CLI utility to manage all system configuration files.

## Prerequisites

- [stow](https://www.gnu.org/software/stow/)

## Setup

These dotfiles are configured to use separate directories for thinking certain things into the system. For example, the `user` directory should only contain user specific configurations, etc.

### Configurations

- `user`
  - **Usage:** `$ stow user`
  - **Description:** Links all the user specific assets to the system.
