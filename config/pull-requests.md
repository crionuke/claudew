# Pull requests: GitHub

Open PRs with `gh` from inside the active repo clone. Target the repo's default branch. Squash merge only.

## Create

```bash
BASE=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
git push -u origin <branch>
gh pr create --base "$BASE" --fill   # Closes #<number> in the body
```

## Monitor

```bash
gh pr checks --watch
```

- **Fail**: show the failing log (`gh run view <run-id> --log-failed`), fix the cause, push.
- **Pass**: continue to Merge.

Check names, counts, and required set vary per repo (see that repo's `.github/workflows/`). Watch every required
check, not just the first to come back. Always monitor — never create a PR and walk away.

## Merge

Merge only once **all required checks pass** and **all review comments are resolved**.

```bash
gh pr view <num> --json reviewDecision,statusCheckRollup,reviewThreads
gh pr merge <num> --squash --delete-branch
```
