#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
DIR="$(printf '%s' "${INPUT}" | jq -r '.workspace.current_dir // .cwd')"
MODEL="$(printf '%s' "${INPUT}" | jq -r '.model.display_name')"
PCT="$(printf '%s' "${INPUT}" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)"

printf '%s %s ctx:%s%%\n' "${DIR}" "${MODEL}" "${PCT}"
