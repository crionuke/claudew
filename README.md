# CLAUDEW

Dockerized Claude Code workers. Three isolated workspaces (`a`, `b`, `c`) so multiple Claude sessions can work in parallel without stepping on each other.

Each worker runs Claude with `--dangerously-skip-permissions` inside a container — full autonomy on tool calls, no permission prompts, and no way for it to touch the host beyond the mounted workspace directory.

## How I use it

**One-shot with `-p`** — hand off a task and walk away:

- **Implement an issue** — `./claudew_a.sh -p "implement issue #32"` and let it churn through reads, edits, builds, and tests without me approving each step.
- **Background PR babysitting** — point worker B at an open PR to watch CI, fix review comments, push fixes, and re-request review while A is doing something else.

**Interactive (no `-p`)** — sit in the REPL and iterate:

- **Parallel tracks** — A on a feature branch, B on a bugfix or doc pass. Separate workspaces and SSH keys, no cross-contamination.
- **Throwaway experiments** — try a risky refactor or a sketchy script in a container; if it goes sideways, nuke the workspace dir, host is untouched.

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
./claudew_c.sh        # start worker C, attach to Claude
```

Each script builds the image if needed, brings up the container, and execs into `claude`. Anything after the script name is forwarded to `claude`:

```bash
./claudew_a.sh -p "fix the failing test"
```

Files live on the host under `./workspace_a`, `./workspace_b`, and `./workspace_c` — edit from your IDE, Claude sees the changes immediately.

## Skills

Drop a skill directory under `./skills/<name>/` and restart the container. The entrypoint refreshes baked-in skills on every start; user-created skills with other names are left alone.

## Stop

```bash
docker compose down
```