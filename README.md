# Dotfiles

Private dotfiles that contains my system configuration and support for work and personal development utilities.

## Dependencies

These are the basic requirements so use the dotfiles locally.

- [devbox](https://www.jetify.com/docs/devbox/installing-devbox)
- [just](https://just.systems/man/en)

## Quick Install

> [!TIP]
>
> Install the dotfiles using this install script OR clone the repo and run the `just link` command. They result in the same thing. You can either use a one-shot command or clone and link it to your system.

```bash
# By default, this installs into ~/.dotfiles
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/latest/install" | bash
```

## Installing Locally

If you want to download the code and then install it, here is what you need to run after downloading it and changing into the projects directory.

```bash
# Run the "install" script to install dotfiles from a cloned repo.
bash install
```

## Getting Started

The general mental model for this is that there are `vX` (version number) directories that handle what is linked into the system so that I can do parallel updates, refactoring, organization, and development of these dotfiles without breaking existing versions that work while I retain existing features and functionality.

> [!TIP]
>
> View available commands

```bash
just
```

## Development

> Install dependencies

```bash
just install
```

## Install

Detects your OS then, if supported, generates install and uninstall scripts.

```bash
just link
```

## Uninstall

Detects the uninstall script and runs it.

> [!TIP]
>
> You can also use `--purge` to flag the `unlink` to purge your system from the dotfiles, entirely. Which runs the same unlinking process for the symlinks but then completely removes the dotfiles from the system by deleting the source code at the end.

```bash
just unlink
```

OR (full purge)

```bash
just unlink --purge
```
