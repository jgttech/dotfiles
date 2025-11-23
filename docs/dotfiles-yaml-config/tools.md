# Dotfiles YAML Config: `tools`

## Structure

```yaml
tools:
  - <home>
```

## Overview

The `tools` section defines which tool configurations the CLI can manage. This is necessary because automatic detection is unreliable due to the variety of possible tool configurations. By explicitly declaring tool paths, the CLI can provide fast and accurate editing capabilities.

## `tools`

Contains path information for all managed tool configurations in the dotfiles repository.

## `tools.<home>`

The `<home>` value is the path to a tool's configuration directory, relative to the `tools/` directory.

**Example:**

```yaml
tools:
  - shared/foo/.config/foo
```

This resolves to the following path relative to the project root:

```
tools/shared/foo/.config/foo
```

**Usage:**

To edit a tool's configuration:

```bash
dotfiles edit foo
dotfiles edit shared/foo
```

To display the path to a tool's configuration:

```bash
dotfiles edit foo --path
dotfiles edit shared/foo --path
```
