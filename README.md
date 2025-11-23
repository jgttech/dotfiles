# Dotfiles

Personal dotfiles managed by a custom Go CLI application. This repository contains configuration files and tools for development environments across multiple operating systems.

## About

This repository consists of three main components:

1. **Go CLI Application**: A command-line tool for managing dotfiles installation, configuration, and editing
2. **Tool Configurations**: Configuration files stored in the `tools/` directory
3. **Configuration State**: A `dotfiles.yml` file that defines system requirements and installation settings

The CLI is designed to handle the complete lifecycle of dotfiles management, including installation, uninstallation, and editing operations.

## Documentation

Documentation is organized in the `docs/` directory:

- [Dotfiles YAML Config](./docs/dotfiles-yaml-config) - Configuration file structure and usage

## Getting Started

Install and setup the repository for development:

```bash
just
```

Verify the CLI installation:

```bash
dotfiles version
```
