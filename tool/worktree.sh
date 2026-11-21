#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: tool/worktree.sh new <task> | rm <task>" >&2
  exit 2
}

fail() {
  echo "worktree: $1" >&2
  exit 1
}

[[ $# -eq 2 ]] || usage
command=$1
task=$2

[[ $task =~ ^[a-z0-9][a-z0-9-]*$ ]] || fail "task must be lowercase letters, digits and dashes: $task"

main_dir=$(cd "$(git rev-parse --git-common-dir)/.." && pwd)
dir="$(dirname "$main_dir")/fujin.worktrees/$task"

new() {
  [[ ! -e $dir ]] || fail "$dir already exists"
  ! git -C "$main_dir" show-ref --verify --quiet "refs/heads/$task" || fail "branch $task already exists"

  git -C "$main_dir" fetch --quiet origin main
  git -C "$main_dir" worktree add --quiet --no-track -b "$task" "$dir" origin/main

  local version
  version=$(sed -n 's/.*"flutter": *"\([^"]*\)".*/\1/p' "$dir/.fvmrc")
  [[ -n $version ]] || fail "no Flutter version in $dir/.fvmrc"
  local sdk="$HOME/fvm/versions/$version"
  [[ -d $sdk ]] || fvm install "$version"
  mkdir "$dir/.fvm"
  ln -s "$sdk" "$dir/.fvm/flutter_sdk"

  direnv allow "$dir"
  (cd "$dir" && direnv exec . flutter pub get)
  (cd "$dir/.omp/extensions/pair-programmer" && bun install --frozen-lockfile)

  echo "$dir"
}

merged() {
  git -C "$main_dir" merge-base --is-ancestor "$task" origin/main ||
    [[ $(gh pr list --repo Ozne-l/fujin --head "$task" --state merged --json number --jq length) -gt 0 ]]
}

rm_worktree() {
  git -C "$main_dir" worktree list --porcelain | grep -qxF "worktree $dir" || fail "no worktree at $dir"
  [[ -z $(git -C "$dir" status --porcelain) ]] || fail "$dir has uncommitted changes"

  direnv revoke "$dir"
  git -C "$main_dir" worktree remove "$dir"

  git -C "$main_dir" fetch --quiet origin main
  if merged; then
    git -C "$main_dir" branch --quiet -D "$task"
  else
    echo "worktree: branch $task kept, its pull request is not merged"
  fi
}

case $command in
  new) new ;;
  rm) rm_worktree ;;
  *) usage ;;
esac
