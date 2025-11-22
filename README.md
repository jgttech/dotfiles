# Dotfiles

These are my personal dotfiles for my system. This repo uses my personal approach to tooling and setup for my preferred development tools on the OS's I personally use.

## About

The repo is with a Go CLI application for management of the dotfiles as well as all the dotfiles configs I like to use in the `tools` directory.

There is also a `dotfiles.yml` which I use as a small piece of state to tell me what the system needs in order for the dotfiles to be installed. On top of that the built-in CLI needs to be capable of being setup and built and using that, solely, to install and uninstall the dotfiles themselves.

## Documentation

The documentation is broken down into the `docs/*` directory.

### [Dotfiles YAML Config](./docs/dotfiles-yaml-config)

Tells you how to use the `dotfiles.yml` configuration.
