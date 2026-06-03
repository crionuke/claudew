#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# iTerm2 color scheme: C = blue
printf '\033]1337;SetColors=tab=2D5FA8\007'
printf '\033]1337;SetColors=cursor=4A8BC2\007'
printf '\033]1337;SetColors=bg=0A1929\007'
printf '\033]0;claudew C\007'
printf '\033]1337;SetUserVar=CLAUDEW=%s\007' "$(printf C | base64)"
trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007\033]1337;SetUserVar=CLAUDEW=\007"' EXIT

docker compose up -d --build claudew_c
docker compose exec claudew_c claudew "$@"
