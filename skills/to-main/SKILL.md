---
name: to-main
description: Checkout the default branch and pull latest changes for repos under ~/workspace. Use when the user wants to sync repos to main/default, "go to main", reset clones to the default branch, or pull updates across all (or specific) workspace repos.
---

# to-main

Checkout each repo's **default branch** (per-repo, not assumed `main`) and `git pull --ff-only`.
Operates on every repo under `~/workspace` unless the user names specific ones.

## Quick start

Run the bundled script and report its summary:

```bash
bash ~/.claude/skills/to-main/scripts/to-main.sh
```

Scope to specific repos by passing path-substring filters:

```bash
bash ~/.claude/skills/to-main/scripts/to-main.sh omgserver byvshev-web
```

## Behavior

- Repos at `~/workspace/<owner>/<repo>` (depth 2, must contain `.git`).
- Default branch detected via `origin/HEAD`, falling back to `git remote set-head --auto`, then `gh repo view`, then `main`.
- **Uncommitted changes → repo is skipped** (never stashed or discarded). Reported as `SKIP`.
- Pull is `--ff-only`; a diverged branch fails loudly rather than creating a merge commit.
- Exit non-zero if any repo failed.

## After running

- Relay the per-repo lines and the final `done: X updated, Y skipped, Z failed` summary.
- If anything was skipped for dirty state, name those repos so the user can commit/stash and re-run.
- If a pull failed (diverged/non-ff), surface the repo and let the user decide — do not force.
