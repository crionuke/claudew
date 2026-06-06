#!/usr/bin/env bash
# Checkout the default branch and pull for repos under ~/workspace.
#
# Usage:
#   sync-repos.sh                 # all repos under ~/workspace
#   sync-repos.sh omgserver       # only repos whose path matches "omgserver"
#   sync-repos.sh omgctl byvshev  # multiple filters (OR-matched)
#
# Repos with uncommitted changes are skipped (never clobbered).

set -uo pipefail

WORKSPACE="${WORKSPACE:-$HOME/workspace}"
FILTERS=("$@")

matches() {
  local path="$1"
  [ ${#FILTERS[@]} -eq 0 ] && return 0
  for f in "${FILTERS[@]}"; do
    [[ "$path" == *"$f"* ]] && return 0
  done
  return 1
}

default_branch() {
  local def
  def=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||')
  if [ -z "$def" ]; then
    git remote set-head origin --auto >/dev/null 2>&1
    def=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||')
  fi
  if [ -z "$def" ]; then
    def=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null)
  fi
  echo "${def:-main}"
}

ok=0 skipped=0 failed=0

for repo in "$WORKSPACE"/*/*; do
  [ -d "$repo/.git" ] || continue
  name="${repo#$WORKSPACE/}"
  matches "$name" || continue
  cd "$repo" || continue

  if [ -n "$(git status --porcelain)" ]; then
    echo "SKIP  $name (uncommitted changes)"
    skipped=$((skipped+1))
    continue
  fi

  def=$(default_branch)
  if ! git checkout "$def" >/dev/null 2>&1; then
    echo "FAIL  $name (checkout $def)"
    failed=$((failed+1))
    continue
  fi

  if out=$(git pull --ff-only 2>&1); then
    if echo "$out" | grep -q "Already up to date"; then
      echo "OK    $name ($def, up to date)"
    else
      echo "OK    $name ($def, pulled)"
    fi
    ok=$((ok+1))
  else
    echo "FAIL  $name ($def, pull): $(echo "$out" | tail -1)"
    failed=$((failed+1))
  fi
done

echo "---"
echo "done: $ok updated, $skipped skipped, $failed failed"
[ "$failed" -eq 0 ]
