# Dotfiles YAML Config: `tools`

> General outline

```yaml
tools:
  - <home>
```

## About

This handles how the CLI knows which tools it can edit, has a namespaced property for them, and a value that configures where the root of the tools configuration is. This required because automatic detection is not clear and there could be anything under a tools configuration. So we need to configure where the user can be dropped in at so editing is smooth and fast.

## `tools`

Contains all the tools path context information for assisting in the editing and tracking of tools in the dotfiles.

## `tools.<home>`

The `<home>` is the path to the home directory for where the a tool exists, relative to the `tools/` directory.

> Example

```yaml
tools:
  - shared/foo/.config/foo
```

This resolves, relative to the project root, to the path:

- `tools/shared/foo/.config/foo`

If I wanted to invoke the `edit` operation on the CLI, we can run and of these:

```bash
dotfiles edit foo
dotfiles edit shared/foo
```

Or, if we just want to see the path to the source, we can run:

```bash
dotfiles edit foo --path
dotfiles edit shared/foo --path
```
