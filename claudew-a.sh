#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# iTerm2 color scheme: A = red
printf '\033]1337;SetColors=tab=B82D2D\007'
printf '\033]1337;SetColors=cursor=D85454\007'
printf '\033]1337;SetColors=bg=1F0808\007'
printf '\033]0;claudew A\007'
printf '\033]1337;SetUserVar=CLAUDEW=%s\007' "$(printf A | base64)"
trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007\033]1337;SetUserVar=CLAUDEW=\007"' EXIT

docker compose up -d --build claudew-a
docker compose exec claudew-a claudew "$@"
