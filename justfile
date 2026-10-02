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

# Bump VERSION, commit, and tag a release
release:
  #!/usr/bin/env bash
  set -euo pipefail

  if [[ -n "$(git status --porcelain)" ]]; then
    echo >&2
    echo "!! ERROR: git worktree is dirty." >&2
    git status --porcelain >&2
    echo >&2
    echo "Aborting." >&2
    exit 1
  fi

  last_tag=$(git describe --tags --abbrev=0 2>/dev/null || true)
  if [[ -n "$last_tag" ]]; then
    echo "Commits since $last_tag:"
    git --no-pager log --oneline "${last_tag}..HEAD"
  else
    echo "No previous tag. All commits:"
    git --no-pager log --oneline
  fi

  echo
  read -rp "New version tag (q or empty to abort): " new_tag

  if [[ -z "$new_tag" || "$new_tag" == "q" ]]; then
    echo "Aborted."
    exit 0
  fi

  version="${new_tag#v}"
  printf '%s\n' "$version" > VERSION
  git add VERSION

  echo
  read -rp "Commit message [misc: release ${new_tag}]: " commit_msg
  commit_msg="${commit_msg:-misc: release ${new_tag}}"
  git commit -m "$commit_msg"

  git tag "$new_tag"
  echo "Tagged $new_tag at $(git rev-parse --short HEAD)"
