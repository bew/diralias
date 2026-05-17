# diralias

Manage directory aliases as named shortcuts, stored as symlinks on the filesystem.

A **change-tick** is incremented on every alias change, allowing editors and shells to
detect when aliases need to be reloaded using a single one-line file read, without polling the
filesystem or calling a process.

## Usage

```
diralias SUB-COMMAND [args...]
```

### Sub-commands

#### `add NAME PATH`

Create an alias `NAME` pointing to `PATH`. `PATH` is resolved to an absolute path.

```
diralias add foo /some/path/to/foo-dir
```

If the alias name already exists, it is overwritten with a warning.

#### `get [PATH]`

Get the alias name for `PATH` (defaults to the current directory `$PWD`).

Exact match — prints just the alias name:
```
$ diralias get /some/path/to/foo-dir
foo
```

Prefix match — prints the alias name and the remaining path suffix:
```
$ diralias get /some/path/to/foo-dir/something/else
foo something/else
```

When multiple aliases are prefixes of the given path, the most specific one (longest
matching target) wins.

Exits non-zero if no alias matches.

#### `list [--include-broken]`

List all aliases as `NAME=PATH` pairs, one per line. Intended for machine use (e.g. shell plugins).

By default only aliases whose target directory still exists are included:

```
$ diralias list
foo=/some/path/to/foo-dir
work=/home/user/projects/work
```

Pass `--include-broken` to also include aliases whose target no longer exists:

```
$ diralias list --include-broken
foo=/some/path/to/foo-dir
gone=/deleted/path
work=/home/user/projects/work
```

#### `path tick-file`

Print the absolute path to the change-tick file.
Useful for editor/shell plugins that want to watch the file directly without hard-coding the path.

```
$ diralias path tick-file
/home/user/.local/state/diralias/change-tick
```

#### `path aliases-dir`

Print the absolute path to the aliases directory.
Useful for editor/shell plugins that need to access the aliases directly.

```
$ diralias path aliases-dir
/home/user/.local/state/diralias/aliases
```

#### `status`

List all aliases and the current change-tick value.

```
$ diralias status
VALID ALIASES: (2)
 • foo  -> /some/path/to/foo-dir
 • work -> ~/projects/work

BROKEN ALIASES: (1)
 • other -> /does/not/exist

CURRENT TICK: '3'
```

> [!NOTE]
> This command is for humans!
> The output format of this command should NOT be used programatically, it may change at any time.

## Storage

Aliases are stored as symlinks under:

```
${XDG_STATE_HOME:-~/.local/state}/diralias/aliases/
```

The change-tick is a plain integer file at:

```
${XDG_STATE_HOME:-~/.local/state}/diralias/change-tick
```

Both are created automatically on first use.

## Notes

- Alias names must not contain `/` or whitespace.
- `diralias get` matches against stored symlink targets as-is (no `realpath` resolution of
  the queried path).
- The change-tick is intended for use by editor/shell plugins that need to know when to
  reload the alias list.
- This tool will later be moved to its own repository with nvim/zsh plugins.
