#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# iTerm2 color scheme: B = orange
printf '\033]1337;SetColors=tab=B8552E\007'
printf '\033]1337;SetColors=cursor=D88454\007'
printf '\033]1337;SetColors=bg=1F1108\007'
printf '\033]0;claudew B\007'
trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007"' EXIT

docker compose up -d --build claudew_b
docker compose exec claudew_b claudew "$@"