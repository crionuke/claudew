# CLAUDEW

Run Claude Code agents fully autonomously in parallel, each sealed in its own
Docker container. Because every worker is a self-contained sandbox that can't
touch your host or the others, you can hand it `--dangerously-skip-permissions`
and let it work end to end — no permission prompts, no babysitting, no risk to
your machine. Launch and color-code them all from a single `open.sh`.

## Use cases

- **Parallelize one project's backlog** — point several agents at different
  issues in the same repo; each works in its own clone and opens its own PR,
  never stepping on the others.
- **Juggle several projects at once** — one agent per repo; switch between tabs
  instead of paging context in and out of your head.
- **Long background jobs** — leave a migration, dependency upgrade, or big
  refactor running in one agent while you build the actual feature in another.
- **Fire and forget** — inside the safe sandbox an agent takes a task all the
  way to a PR on its own, no approvals or babysitting; walk away or go to sleep.

## Usage

```bash
git clone https://github.com/crionuke/claudew.git
cd claudew
cp .env.sample .env   # set GIT_USER_NAME, GIT_USER_EMAIL, GH_TOKEN, CONTEXT7_API_KEY

./open.sh -i          # all agents, each in its own iTerm2 tab
```

`open.sh` builds and starts each worker on demand. `-i` opens every agent in its
own iTerm2 tab. To run a single agent in the current terminal, use `-a`, `-b`,
or `-c` (red, green, blue). Run with no argument to print usage.

Workspaces: `./volumes/worker_a`, `./volumes/worker_b`, `./volumes/worker_c`.

## Agent rules

Shared instructions in `./config/` that every worker follows across every repo,
copied into each `~/workspace/` on start. A per-repo file of the same name wins.

- **`CLAUDE.md`** — master ruleset (tone, repo layout, PR flow, coding standards).
- **`pull-requests.md`** — opening, checking, and merging PRs with `gh`.
- **`issue-tracker.md`** — GitHub Issues for issues and PRDs.
- **`triage-labels.md`** — triage roles and their default labels.
- **`java-rules.md`** — Java/Jakarta rules, applied only in Java repos.

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
