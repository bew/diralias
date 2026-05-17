# diralias zsh plugin
#
# Manages `hash -d` named directory aliases, kept in sync with the diralias
# state via the change-tick file. Checks the tick on every precmd and only
# re-defines aliases when the tick has changed.

_diralias_bin="${DIRALIAS_BIN:-diralias}"
_diralias_tick_file="$("$_diralias_bin" path tick-file 2>/dev/null)"
_diralias_last_tick=""
_diralias_active_hashes=()
_diralias_first_load=true

# Reload dir aliases if needed
function _diralias_reload() {
  [[ -z "$_diralias_tick_file" ]] && return

  local current_tick
  current_tick="$(< "$_diralias_tick_file")" 2>/dev/null || return
  [[ "$current_tick" == "$_diralias_last_tick" ]] && return
  _diralias_last_tick="$current_tick"

  # Unhash previously defined names
  local name
  for name in "${_diralias_active_hashes[@]}"; do
    unhash -d "$name" 2>/dev/null
  done
  _diralias_active_hashes=()

  # Re-define all currently valid aliases
  local target
  while IFS='=' read -r name target; do
    hash -d "$name"="$target"
    _diralias_active_hashes+=("$name")
  done < <("$_diralias_bin" list 2>/dev/null)

  if ! $_diralias_first_load; then
    echo "diralias: tick changed, ${#_diralias_active_hashes} aliases reloaded"
  fi
}

# Show status of the diralias plugin in current shell
function _diralias_status() {
  echo "diralias: plugin status for current shell:"
  echo "diralias: ${#_diralias_active_hashes} aliases loaded: ${_diralias_active_hashes[*]}"
}

# Warn if the diralias bin is not available
if ! "$_diralias_bin" --help 2>/dev/null >/dev/null; then
  echo "diralias: Binary $_diralias_bin does not exist, zsh hook inactive"
fi

autoload -Uz add-zsh-hook
add-zsh-hook precmd _diralias_reload

# Initial alias load
_diralias_reload
_diralias_first_load=false
