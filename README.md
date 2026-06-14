# CLAUDEW

*Built to collaborate, not to work autonomously.*

Run multiple Claude Code agents in parallel, each sealed in its own color-coded
Docker sandbox loaded with **your** dev tools, rules, and skills. Since a sandbox
can't touch your host or the other agents, you can run it with
`--dangerously-skip-permissions` and let it work without gating each step — you
still review and merge. Each agent carries a multi-repo workspace, so it can take
a cross-cutting task across every affected repo and open a PR in each. Launch and
color-code them all from a single `open.sh`.

> **This repo ships tuned to my own stack** — Java/Quarkus, GitHub flow, iTerm2,
> and the skills in `./home/`. None of it is load-bearing: swap the home-skeleton
> files, drop or add skills, and change the base image in `docker/Dockerfile` to
> fit your tooling. The core idea stays the same.

## Use cases

- **Parallelize one backlog** — several agents on different issues in one repo, each with its own clone and PR.
- **Hand off, then review** — an agent goes all the way to a PR; you keep review and merge.
- **Cross-repo changes** — one agent edits every affected repo and opens a PR in each.
- **Juggle several projects** — one agent per repo, one tab each.
- **Long background jobs** — park a migration or big refactor in one agent while you build in another.
- **Bootstrap new projects** — an agent scaffolds a fresh repo following your existing conventions.

## Usage

Clone the repo and fill in `.env` using `.env.sample` as a template. Then launch
the agents:

```bash
./open.sh -i          # all agents, each in its own iTerm2 tab
```

`open.sh` builds and starts each worker on demand. `-i` opens every agent in its
own iTerm2 tab. To run a single agent in the current terminal, use `-A`, `-B`,
`-C`, or `-D`. Run with no argument to print usage.
