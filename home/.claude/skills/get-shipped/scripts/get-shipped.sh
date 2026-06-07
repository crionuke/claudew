#!/usr/bin/env bash
# Collect merged pull requests across all repos under ~/workspace for a period.
# Emits a raw, per-repo log; the agent composes the narrative summary from it.
#
# Usage:
#   get-shipped.sh                      # merged today (all repos)
#   get-shipped.sh yesterday            # merged yesterday
#   get-shipped.sh 7d                   # merged in the last 7 days
#   get-shipped.sh 30d                  # merged in the last 30 days
#   get-shipped.sh 2026-06-01           # merged on a single day
#   get-shipped.sh 2026-06-01..2026-06-07   # merged in an explicit range
#   get-shipped.sh 7d omgserver         # period + path-substring filters
#
# All authors are included. Repos without a usable GitHub remote are skipped.

set -uo pipefail

WORKSPACE="${WORKSPACE:-$HOME/workspace}"

PERIOD=""
FILTERS=()
for arg in "$@"; do
  case "$arg" in
    today|yesterday|7d|week|30d|month|????-??-??|????-??-??..????-??-??)
      [ -z "$PERIOD" ] && PERIOD="$arg" || FILTERS+=("$arg") ;;
    *) FILTERS+=("$arg") ;;
  esac
done

period_to_range() {
  case "${1:-today}" in
    ""|today)     echo "$(date +%F)..$(date +%F)" ;;
    yesterday)    local d; d=$(date -d yesterday +%F); echo "$d..$d" ;;
    7d|week)      echo "$(date -d '7 days ago' +%F)..$(date +%F)" ;;
    30d|month)    echo "$(date -d '30 days ago' +%F)..$(date +%F)" ;;
    *..*)         echo "$1" ;;
    *)            echo "$1..$1" ;;
  esac
}

matches() {
  [ ${#FILTERS[@]} -eq 0 ] && return 0
  for f in "${FILTERS[@]}"; do
    [[ "$1" == *"$f"* ]] && return 0
  done
  return 1
}

RANGE=$(period_to_range "$PERIOD")
echo "period: $RANGE  (all authors, source: merged PRs)"
echo "==="

repos=0 with_prs=0 total_prs=0 skipped=0

for repo in "$WORKSPACE"/*/*; do
  [ -d "$repo/.git" ] || continue
  name="${repo#$WORKSPACE/}"
  matches "$name" || continue
  cd "$repo" || continue
  repos=$((repos+1))

  if ! out=$(gh pr list --state merged --limit 200 \
        --search "merged:$RANGE" \
        --json number,title,author,mergedAt,url \
        --jq '.[] | "#\(.number)\t\(.mergedAt[0:10])\t@\(.author.login)\t\(.title)\t\(.url)"' 2>/dev/null); then
    echo "SKIP  $name (no gh access / no GitHub remote)"
    skipped=$((skipped+1))
    continue
  fi

  if [ -z "$out" ]; then
    continue
  fi

  count=$(printf '%s\n' "$out" | grep -c .)
  with_prs=$((with_prs+1))
  total_prs=$((total_prs+count))
  echo "## $name  ($count merged)"
  printf '%s\n' "$out"
  echo
done

echo "==="
echo "done: $total_prs merged PRs across $with_prs/$repos repos, $skipped skipped"
