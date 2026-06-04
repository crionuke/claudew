#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

osascript <<EOF
tell application "iTerm2"
    activate
    if (count of windows) = 0 then
        create window with default profile
    end if
    tell current window
        set tab_a to (create tab with default profile)
        tell current session of tab_a
            write text "exec '$DIR/worker-a.sh'"
        end tell
        set tab_b to (create tab with default profile)
        tell current session of tab_b
            write text "exec '$DIR/worker-b.sh'"
        end tell
        set tab_c to (create tab with default profile)
        tell current session of tab_c
            write text "exec '$DIR/worker-c.sh'"
        end tell
    end tell
end tell
EOF
