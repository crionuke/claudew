#!/usr/bin/env bash
set -e

# Readiness marker — consumed by the compose healthcheck so `docker compose exec`
# doesn't race the setup steps below. Cleared on start, written just before exec.
READY_MARKER=/opt/claudew/.ready
rm -f "$READY_MARKER"

# SSH key — generated on first run so it lives inside whatever is mounted at $HOME
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -N "" -C "$GIT_USER_EMAIL" -f "$HOME/.ssh/id_ed25519"
    ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
    chmod 600 "$HOME/.ssh/id_ed25519"
    chmod 644 "$HOME/.ssh/id_ed25519.pub"
    [ -f "$HOME/.ssh/known_hosts" ] && chmod 644 "$HOME/.ssh/known_hosts"
fi

# Git identity
if [ ! -f "$HOME/.gitconfig" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
    git config --global init.defaultBranch main
fi

# Home skeleton — baked into the image, overlaid onto $HOME on every start.
# ~/.claude/CLAUDE.md + ~/.claude/rules/ load as user instructions across every repo; ~/docs/ holds reference docs pulled in on demand.
# Baked-in skills and subagents are removed first so the overlay writes them fresh (drops files deleted upstream); user-created ones with other names survive.
HOME_SKEL=/opt/claudew/home
if [ -d "$HOME_SKEL" ]; then
    for skill in "$HOME_SKEL"/.claude/skills/*/; do
        [ -d "$skill" ] || continue
        rm -rf "$HOME/.claude/skills/$(basename "$skill")"
    done
    for agent in "$HOME_SKEL"/.claude/agents/*; do
        [ -f "$agent" ] || continue
        rm -f "$HOME/.claude/agents/$(basename "$agent")"
    done
    cp -af "$HOME_SKEL"/. "$HOME/"
fi

# Status line — point Claude Code at the baked status line so every session shows the worker dir,
# model, and live context-window usage; merged into settings.json so other settings survive.
SETTINGS_FILE="$HOME/.claude/settings.json"
STATUS_LINE="$(jq -n --arg cmd "$HOME/.claude/statusline.sh" '{type: "command", command: $cmd}')"
mkdir -p "$HOME/.claude"
if [ -f "$SETTINGS_FILE" ]; then
    TMP_SETTINGS="$(mktemp)"
    jq --argjson sl "$STATUS_LINE" '.statusLine = $sl' "$SETTINGS_FILE" > "$TMP_SETTINGS"
    mv "$TMP_SETTINGS" "$SETTINGS_FILE"
else
    jq -n --argjson sl "$STATUS_LINE" '{statusLine: $sl}' > "$SETTINGS_FILE"
fi

# Port forwarding — bridge the worker's localhost to the host gateway so tools that assume a
# service on localhost reach a stack whose ports are published on the host (e.g. one brought up
# via env/run.sh). Listed in FORWARDED_PORTS; off when unset.
for port in ${FORWARDED_PORTS:-}; do
    socat TCP-LISTEN:"$port",fork,reuseaddr TCP:host.docker.internal:"$port" &
done

touch "$READY_MARKER"

exec "$@"
