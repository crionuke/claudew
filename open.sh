#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
DIR="$(pwd)"

usage() {
    cat <<EOF
usage: open.sh (-i | -a | -b | -c)

  -i       open worker_a, worker_b and worker_c, each in its own iTerm tab
  -a       run only the worker_a session in the current terminal
  -b       run only the worker_b session in the current terminal
  -c       run only the worker_c session in the current terminal
EOF
}

run_worker() {
    local id="$1"
    local name service tab cursor bg
    case "$id" in
        a) name=A; service=worker_a; tab=B82D2D; cursor=D85454; bg=1F0808 ;;
        b) name=B; service=worker_b; tab=2D8B3F; cursor=5AC272; bg=091911 ;;
        c) name=C; service=worker_c; tab=2D5FA8; cursor=4A8BC2; bg=0A1929 ;;
    esac

    printf '\033]1337;SetColors=tab=%s\007' "$tab"
    printf '\033]1337;SetColors=cursor=%s\007' "$cursor"
    printf '\033]1337;SetColors=bg=%s\007' "$bg"
    printf '\033]0;claudew %s\007' "$name"
    printf '\033]1337;SetUserVar=CLAUDEW=%s\007' "$(printf '%s' "$name" | base64)"
    trap 'printf "\033]1337;SetColors=tab=\007\033]1337;SetColors=cursor=\007\033]1337;SetColors=bg=\007\033]0;\007\033]1337;SetUserVar=CLAUDEW=\007"' EXIT

    docker compose up -d --build --wait "$service"
    docker compose exec "$service" claudew
}

open_all() {
    osascript <<EOF
tell application "iTerm2"
    activate
    if (count of windows) = 0 then
        create window with default profile
    end if
    tell current window
        set tab_a to (create tab with default profile)
        tell current session of tab_a
            write text "exec '$DIR/open.sh' -a"
        end tell
        set tab_b to (create tab with default profile)
        tell current session of tab_b
            write text "exec '$DIR/open.sh' -b"
        end tell
        set tab_c to (create tab with default profile)
        tell current session of tab_c
            write text "exec '$DIR/open.sh' -c"
        end tell
    end tell
end tell
EOF
}

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

case "$1" in
    -i) open_all ;;
    -a) run_worker a ;;
    -b) run_worker b ;;
    -c) run_worker c ;;
    -h|--help) usage ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 1 ;;
esac
