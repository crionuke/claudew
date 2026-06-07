# CLAUDEW

Run Claude Code agents fully autonomously in parallel, each sealed in its own
Docker container. Because every worker is a self-contained sandbox that can't
touch your host or the others, you can hand it `--dangerously-skip-permissions`
and let it work end to end — no permission prompts, no babysitting, no risk to
your machine. Launch and color-code them all from a single `open.sh`.

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
./open.sh -iterm   # all three, each in its own iTerm2 tab
./open.sh -a       # only worker_a (red)
./open.sh -b       # only worker_b (green)
./open.sh -c       # only worker_c (blue)
```

`-iterm` opens three iTerm2 tabs (A, B, C), each running its worker. `-a`, `-b`,
or `-c` runs a single worker session in the current terminal. Run with no
argument to print usage. Extra args after the flag are passed through to
`claudew`.

Workspaces: `./volumes/worker_a`, `./volumes/worker_b`, `./volumes/worker_c`.

## Skills

Bundled under `./skills/`, synced to `~/.claude/skills` on start.

- **Docs & research** — `find-docs`, `seo-audit`
- **Planning & tracking** — `to-prd`, `to-issues`, `triage`, `grill-with-docs`
- **Building & refactoring** — `tdd`, `prototype`, `improve-codebase-architecture`, `zoom-out`
- **Workspace & handoff** — `sync-repos`, `handoff`
- **Skill authoring** — `write-a-skill`, `setup-matt-pocock-skills`
