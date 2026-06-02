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
        set orig_bounds to bounds
        set new_tab to (create tab with default profile)
        set pane_r to current session of new_tab
        set total_cols to columns of pane_r
        set side_cols to (total_cols * 0.175) as integer
        tell pane_r
            write text "exec '$DIR/claudew_r.sh'"
            set pane_g to (split vertically with same profile)
        end tell
        tell pane_g
            write text "exec '$DIR/claudew_g.sh'"
            set pane_b to (split vertically with same profile)
        end tell
        tell pane_b
            write text "exec '$DIR/claudew_b.sh'"
        end tell
        -- Resize R/B narrow so G gets ~65%, then restore window size
        -- (setting columns resizes the window; restoring bounds keeps proportions)
        set columns of pane_r to side_cols
        set columns of pane_b to side_cols
        set bounds to orig_bounds
    end tell
end tell
EOF
