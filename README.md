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
./worker_a.sh   # red
./worker_b.sh   # green
./worker_c.sh   # blue
```

Workspaces: `./volumes/worker_a`, `./volumes/worker_b`, `./volumes/worker_c`.

### All three (iTerm2)

```bash
./open.sh
```

Opens three tabs (A, B, C), each running its worker.

## Skills

Bundled under `./skills/`, synced to `~/.claude/skills` on start.

- **Docs & research** — `find-docs`, `seo-audit`
- **Planning & tracking** — `to-prd`, `to-issues`, `triage`, `grill-with-docs`
- **Building & refactoring** — `tdd`, `prototype`, `improve-codebase-architecture`, `zoom-out`
- **Workspace & handoff** — `sync-repos`, `handoff`
- **Skill authoring** — `write-a-skill`, `setup-matt-pocock-skills`
