# diralias

Manage directory aliases as named shortcuts, stored as symlinks on the filesystem.

A **change-tick** is incremented on every alias change, allowing editors and shells to
detect when aliases need to be reloaded using a single one-line file read, without polling the
filesystem or calling a process.

Checkout CLI documentation at [./CLI_USAGE.md](./CLI_USAGE.md).

## Storage

The runtime state storage is created automatically on first use.

Aliases are stored as symlinks under:
```
${XDG_STATE_HOME:-~/.local/state}/diralias/aliases/
```
The change-tick is a plain integer file at:
```
${XDG_STATE_HOME:-~/.local/state}/diralias/change-tick
```

## Notes

- Alias names must not contain `/` or whitespace.
- `diralias get` matches against stored symlink targets as-is (no `realpath` resolution of
  the queried path).
- The change-tick is intended for use by editor/shell plugins that need to know when to
  reload the alias list.
- This tool will later be moved to its own repository with nvim/zsh plugins.
