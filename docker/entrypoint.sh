#!/usr/bin/env bash
set -e

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

# Workspace dir — where Claude sessions are rooted
mkdir -p "$HOME/workspace"

# Global workspace config (CLAUDE.md, etc.) — baked into the image, refreshed on every start.
CONFIG_SRC=/opt/claudew/config
if [ -d "$CONFIG_SRC" ]; then
    cp -af "$CONFIG_SRC"/. "$HOME/workspace/"
fi

# Copy baked-in project skills into ~/.claude/skills, refreshed on every start.
# Only the baked-in names are touched — user-created skills with other names survive.
SKILLS_SRC=/opt/claudew/skills
SKILLS_DST="$HOME/.claude/skills"
if [ -d "$SKILLS_SRC" ]; then
    mkdir -p "$SKILLS_DST"
    for skill in "$SKILLS_SRC"/*/; do
        [ -d "$skill" ] || continue
        name=$(basename "$skill")
        target="$SKILLS_DST/$name"
        rm -rf "$target"
        cp -a "$skill" "$target"
    done
fi

exec "$@"
