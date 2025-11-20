# Personal Dotfiles

My personal dotfiles.

## Prerequisites

Required for development:

- [direnv](https://direnv.net)
- [aqua](https://aquaproj.github.io)
- [just](https://just.systems/man/en)

## Getting Started

Install project tools and dependencies:

```bash
just
```

Test the development CLI:

```bash
dotfiles <args>
```

## How It Works

This project uses `direnv` to automatically manage your development environment. When you enter this directory, tools are added to your `PATH`. When you leave, they are removed.

All system packages and project dependencies are ephemeral and contained within the project directory. Removing the project removes everything except the prerequisites.

The `dotfiles` command is a wrapper that runs within a persistent development container.

## Architecture

The toolchain follows this hierarchy: `direnv` > `just` > `aqua`

- `direnv` automatically activates the `.envrc` file when entering this directory
- `just` handles all task execution and command orchestration
- `aqua` installs system packages locally within the project, not globally

Everything flows from this foundation. For example, `aqua` installs `mise`, which then installs `go` at the project level.
