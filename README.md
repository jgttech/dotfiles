# Dotfiles

Private dotfiles that contains my system configuration and support for work and personal development utilities.

## Dependencies

These are the basic requirements so use the dotfiles locally.

- [git](https://git-scm.com) (usually already installed)
- [yq](https://github.com/mikefarah/yq/#install)
- [devbox](https://www.jetify.com/docs/devbox/installing-devbox)
- [just](https://just.systems/man/en)

## Quick Install

> [!TIP]
>
> Install the dotfiles using this install script OR clone the repo and run the `bash install` command. They result in the same thing. You can either use a one-shot command or clone and link it to your system.

```bash
# By default, this installs into ~/.dotfiles
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/latest/install" | bash
```

## Installing Locally

If you want to download the code and then install it, here is what you need to run after downloading it and changing into the projects directory.

```bash
bash install
```

## Getting Started

> [!TIP]
>
> These commads are the common commands for managing the dotfiles. For other commands, use `just` to see what is available if it is not listed here.

| Command | Description |
|:-|:-|
| `just build` | Build install assets for dotfiles. |
| `just install` | Run build assets for installing dotfiles. |
| `just uninstall` | Run build assets for removing dotfiles. |
| `just uninstall --purge` | Run build assets for removing and deleting dotfiles from the system entirely. |
| `just clean` | Delete local development resources/dependencies. |
| `just clean --purge` | Delete local development resources/dependencies and remove devbox store.  |
