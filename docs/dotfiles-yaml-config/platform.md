# Dotfiles YAML Config: `platform`

> General outline

```yaml
platform:
  <os>:
    package-manager:
      <method>: <pm>|<symbol>
    depenencies:
      <pm>:
        <key>: <package>
```

## About

This configures how the CLI handles the setup work required to get itself installed on your system.

<br />

## Available Package Managers

List of available packages managers in a central area here in the documentation to make it easy to update and maintain.

- `pacman`
- `brew`
- `detect` (**`<symbol>`**)
  - This symbol tells the CLI to perform it's own internal check for a package manager. It will result in one of the available options or return the fallback option. If no fallback option is given, it will return an empty string.

<br />

## `platform`

Contains OS-specific configuration for supporting a particular platform.

<br />

## `platform.<os>`

The `<os>` is the supported OS for the dotfiles. Each supported OS must be backed by the CLI, itself. These are not arbitrary values.

> Available OS's

- `linux`
- `macos`

<br />

## `platform.<os>.package-manager.<method>`

The `<method>` is when a package manager should be used.

> Available Methods

- `default`
  - The default method for the package manager to be used.
- `fallback`
  - The fallback method for the package manager to be used if `default` fails to detect a package manager.

<br />

## `platform.<os>.package-manager.<method>: <pm>|<symbol>`

The `<pm>` is a name of an available package manager that the CLI supports.

<br />

## `platform.<os>.dependencies.<pm>`

The `<PM>` is a name of an available package manager that the CLI supports.

<br />

## `platform.<os>.pependencies.<pm>.<key>.<package>`

The `<key>` is a common name you want to use for that package. The `<package>` is the exact package that the package manager needs to install to support installing that package.

The use case would be for things that are not clear, like choosing to install the git source and build the package as opposed to using a pre-built binary. or maybe using a third-party alternative instead of whatever else. This creates a common interface over a package that can be installed by different names, in different package manager, behind the scenes with a common name.
