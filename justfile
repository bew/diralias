# This file is a set of tasks to be run by the `just` command runner:
# https://github.com/casey/just

_default:
  @{{ just_executable() }} --list

# ----------------------------------------

alias tu := test-units
# Run the test suite
test-units:
  bats diralias.bats

# Build the package with Nix
build:
  nix build
