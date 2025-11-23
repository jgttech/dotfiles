# Dotfiles YAML Config: `platform`

## Structure

```yaml
platform:
  <os>:
    package-manager:
      <method>: <pm>|<symbol>
    dependencies:
      <pm>:
        <key>: <package>
```

## Overview

The `platform` section configures OS-specific settings and dependencies required for the CLI to install and manage dotfiles on your system.

## Available Package Managers

The CLI supports the following package managers:

- `pacman` - Arch Linux package manager
- `brew` - Homebrew package manager for macOS and Linux
- `detect` - Special symbol that instructs the CLI to automatically detect the system package manager. Returns the detected package manager, the configured fallback option, or an empty string if no fallback is specified.

## `platform`

Contains operating system-specific configuration for each supported platform.

## `platform.<os>`

Specifies the target operating system. Supported values are defined by the CLI implementation and are not arbitrary.

**Supported Operating Systems:**

- `linux`
- `macos`

## `platform.<os>.package-manager.<method>`

Defines the package manager selection method for the operating system.

**Available Methods:**

- `default` - The primary package manager to use
- `fallback` - The package manager to use if the default cannot be detected or is unavailable

## `platform.<os>.package-manager.<method>: <pm>|<symbol>`

The value is either a package manager name or a special symbol (such as `detect`).

## `platform.<os>.dependencies.<pm>`

Groups dependencies by package manager. The `<pm>` must be a supported package manager name.

## `platform.<os>.dependencies.<pm>.<key>: <package>`

Maps a common dependency name to a package manager-specific package name.

- `<key>` - A common identifier for the dependency
- `<package>` - The exact package name used by the specified package manager

**Use Case:**

This mapping allows for a consistent dependency interface across different package managers. For example, you can use a common key like `git-cli` that maps to `git` in one package manager and `git-core` in another. This is useful when package names differ across package managers or when choosing between different installation methods (e.g., source build vs. pre-built binary).
