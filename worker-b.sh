#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# iTerm2 color scheme: B = green
printf '\033]1337;SetColors=tab=2D8B3F\007'
printf '\033]1337;SetColors=cursor=5AC272\007'
printf '\033]1337;SetColors=bg=091911\007'
printf '\033]0;claudew B\007'
printf '\033]1337;SetUserVar=CLAUDEW=%s\007' "$(printf B | base64)"
trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007\033]1337;SetUserVar=CLAUDEW=\007"' EXIT

docker compose up -d --build worker-b
docker compose exec worker-b claudew "$@"
