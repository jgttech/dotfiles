# Personal Dotfiles

My personal dotfiles.

## Pre-requisites

These are required for any development to work.

- [direnv](https://direnv.net)
- [aqua](https://aquaproj.github.io)
- [just](https://just.systems/man/en)

## Getting Started

This project installs system tools and dependencies that utilize `direnv` to augment your local `PATH` with project specific configuration. When you change directory **_outside_** the project path, they are **_automatically_** unloaded from your local `PATH`. It's fully managed by the project, itself. **_ALL_** system packages and project dependencies are ephemoral and are 100% removed when the project is removed. The only exception is the prerequisites.

> [!INFO]
>
> - The installation process configures some additional tools in your `PATH` (see `.envrc`).
> - Development can be done with the `dotfiles` command, assuming the project is setup correctly.
> - The `dotfiles` CLI runs within a persistenty active container for development.

---

```bash
# Install project system tools and dependencies.
just
```

```bash
# Test the development CLI.
dotfiles
```

## About

The process this project uses is `direnv` > `just` > `aqua`. The `direnv` package automatically manages your development environment locally on your system and activates this projects `.envrc` file when entering this projects directory. The `just` package handles all command running tasks, this includes integrations that need to run a series of operations to perform a task (i.e like the `dotfiles` CLI in `dev/dotfiles` that gets added to the path, this calls `just dotfiles $@`, allowing me to leverage `just` for dev tooling without polluting the CLI commands the repo can use). Lastly, the `aqua` package is used to install, locally within this project **_(NOT within your system)_** the system packages needed to do development within this repo. Everything else, from there, will flow (i.e `mise` is used to install `go` to the project manages it's own version of `go`, but the installation of `mise` is handled by `aqua`, which is invoke within a `just` command).
