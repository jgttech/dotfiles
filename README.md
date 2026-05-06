# Dotfiles

Private dotfiles that contains my system configuration and support for work and personal development utilities.

## Dependencies

These are the basic requirements so use the dotfiles locally.

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

> Setup an initial build and install devbox depenencies.

```bash
just build
```

> Install the dotfiles, locally.

```bash
just install
```

> Uninstall the dotfiles, locally, but does NOT delete the source code.

```bash
just uninstall
```

> Uninstall the dotfiles, locally, AND destroy the source by deleting it, after removing the symlinks.

```bash
just uninstall --purge
```
