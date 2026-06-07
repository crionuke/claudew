# CLAUDEW

*Built to collaborate, not to work autonomously.*

Run multiple Claude Code agents in parallel, each sealed in its own color-coded
Docker sandbox loaded with **your** dev tools, rules, and skills. Because every
worker is a self-contained sandbox that can't touch your host or the others, you
can hand it `--dangerously-skip-permissions` and skip the permission prompts on
every step. You stay the one who reviews and merges — the sandbox just lets the
agent move without you gating each action. Each worker carries a multi-repo
workspace, so you can hand one agent a cross-cutting task and let it edit every
affected repo and open a PR in each. Launch and color-code them all from a
single `open.sh`.

> **This repo ships tuned to my own preferences and tech stack** — Java/Quarkus
> rules, GitHub flow, iTerm2 launcher, the specific skills and coding standards
> in `./config/` and `./skills/`. None of it is load-bearing. Swap the config
> files, drop or add skills, change the base image in `docker/Dockerfile` to
> whatever language and tooling you use. The core idea — multiple Claude Code
> agents running in parallel, each sealed in its own throwaway sandbox — and the
> advantages that come with it stay exactly the same whoever you are.

## Use cases

- **Parallelize one project's backlog** — point several agents at different
  issues in the same repo; each works in its own clone and opens its own PR,
  never stepping on the others.
- **Juggle several projects at once** — one agent per repo; switch between tabs
  instead of paging context in and out of your head.
- **Long background jobs** — keep a migration, dependency upgrade, or big
  refactor moving in one agent while you build the actual feature in another.
- **Hand off, then review** — inside the safe sandbox an agent takes a task all
  the way to a PR; you hold the control points (review, merge), not every
  intermediate step.
- **Ship a change across repos at once** — hand one agent a cross-cutting task
  and let it edit every affected repo in its workspace and open a PR in each.
- **Bootstrap new projects from your own** — let an agent scaffold a fresh repo
  and fill it in, mirroring the structure and conventions of the projects
  already in its workspace.

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
