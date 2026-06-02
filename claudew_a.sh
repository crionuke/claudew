#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# iTerm2 color scheme: A = blue
printf '\033]1337;SetColors=tab=2D5FA8\007'
printf '\033]1337;SetColors=cursor=4A8BC2\007'
printf '\033]1337;SetColors=bg=0A1929\007'
printf '\033]0;claudew A\007'
trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007"' EXIT

docker compose up -d --build claudew_a
docker compose exec claudew_a claudew "$@"