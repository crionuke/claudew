# CLAUDEW

Run Claude Code agents fully autonomously in parallel, each sealed in its own
Docker container. Because every worker is a self-contained sandbox that can't
touch your host or the others, you can hand it `--dangerously-skip-permissions`
and let it work end to end — no permission prompts, no babysitting, no risk to
your machine. Launch and color-code them all from a single `open.sh`.

## Setup

1. `cp .env.sample .env` and set `GIT_USER_NAME`, `GIT_USER_EMAIL`, `GH_TOKEN`, `CONTEXT7_API_KEY`.
2. Start Docker.

## Run

```bash
./open.sh      # all three, each in its own iTerm2 tab
./open.sh -a   # only worker_a (red)
./open.sh -b   # only worker_b (green)
./open.sh -c   # only worker_c (blue)
```

With no argument, `open.sh` opens three iTerm2 tabs (A, B, C), each running its
worker. With `-a`, `-b`, or `-c` it runs a single worker session in the current
terminal. Extra args after the flag are passed through to `claudew`.

Workspaces: `./volumes/worker_a`, `./volumes/worker_b`, `./volumes/worker_c`.

## Config

Shared instructions that govern how every agent behaves across every repo.
Files under `./config/` are baked into the image and copied into each worker's
`~/workspace/` on every start, so all workers stay in sync and edits land on
the next restart. Because they live at the workspace root, a per-repo
`CLAUDE.md` (or `triage-labels.md`, etc.) overrides them on conflict.

- **`CLAUDE.md`** — the master ruleset: response tone, repo layout, the
  branch → PR → merge flow, and coding standards. Pulls in the files below.
- **`pull-requests.md`** — how to open, check, and squash-merge PRs with `gh`.
- **`issue-tracker.md`** — using GitHub Issues for issues and PRDs via `gh`.
- **`triage-labels.md`** — canonical triage roles and their default label strings.
- **`java-rules.md`** — Java/Jakarta coding rules, applied only in Java repos.

## Skills

Bundled under `./skills/`, synced to `~/.claude/skills` on start.

- **Docs & research** — `find-docs`, `seo-audit`
- **Planning & tracking** — `to-prd`, `to-issues`, `triage`, `grill-with-docs`
- **Building & refactoring** — `tdd`, `prototype`, `improve-codebase-architecture`, `zoom-out`
- **Workspace & handoff** — `sync-repos`, `handoff`
- **Skill authoring** — `write-a-skill`, `setup-matt-pocock-skills`

## Stack

- Ubuntu 24.04, Node.js 22, Claude Code
- Java 25 + 21 (Temurin, 25 default) + Quarkus CLI via SDKMAN
- `gh`, `docker` CLI (Compose + Buildx plugins)
- Per-worker SSH key + git identity
