# CLAUDEW

Dockerized Claude Code workers. Two isolated workspaces (`a`, `b`) so two Claude sessions can work in parallel without stepping on each other.

## What's inside

- Ubuntu 24.04 + Node.js 22 + Claude Code (`--dangerously-skip-permissions`)
- Java 25 (Temurin) + Quarkus CLI via SDKMAN
- `gh`, `docker` CLI (talks to host Docker via mounted socket)
- Project skills from `./skills/` auto-copied into `~/.claude/skills` on start
- Per-worker SSH key + git identity, persisted in the mounted workspace

## Setup

1. `cp .env.sample .env` and fill in:
   - `GIT_USER_NAME`, `GIT_USER_EMAIL` — baked into the image, used for git + SSH key
   - `GH_TOKEN` — GitHub PAT for `gh`
   - `CONTEXT7_API_KEY` — for `ctx7` doc lookups
2. Make sure Docker is running.

## Use

```bash
./claudew_a.sh        # start worker A, attach to Claude
./claudew_b.sh        # start worker B, attach to Claude
```

Each script builds the image if needed, brings up the container, and execs into `claude`. Anything after the script name is forwarded to `claude`:

```bash
./claudew_a.sh -p "fix the failing test"
```

Files live on the host under `./workspace_a` and `./workspace_b` — edit from your IDE, Claude sees the changes immediately.

## Skills

Drop a skill directory under `./skills/<name>/` and restart the container. The entrypoint refreshes baked-in skills on every start; user-created skills with other names are left alone.

## Stop

```bash
docker compose down
```