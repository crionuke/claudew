# CLAUDEW

Three Dockerized Claude Code workers (`a`, `b`, `c`) running in parallel with `--dangerously-skip-permissions`.

## Stack

- Ubuntu 24.04, Node.js 22, Claude Code
- Java 25 (Temurin) + Quarkus CLI via SDKMAN
- `gh`, `docker` CLI
- Skills from `./skills/` synced to `~/.claude/skills` on start
- Per-worker SSH key + git identity

## Setup

1. `cp .env.sample .env` and set `GIT_USER_NAME`, `GIT_USER_EMAIL`, `GH_TOKEN`, `CONTEXT7_API_KEY`.
2. Start Docker.

## Run

```bash
./claudew_a.sh   # red
./claudew_b.sh   # green
./claudew_c.sh   # blue
```

Workspaces: `./workspace_a`, `./workspace_b`, `./workspace_c`.

### All three (iTerm2)

```bash
./iterm.sh
```

Opens three tabs (A, B, C), each running its worker.
