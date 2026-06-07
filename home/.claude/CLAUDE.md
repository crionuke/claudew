# CLAUDEW

Applies to every repo under `~/workspace`. Per-repo `CLAUDE.md` wins on conflict.

## Response tone

- Direct, without filler.
- Push back when something wrong.
- Code first, explanation second.
- Name trade-offs with a recommendation.

## Where you are

`~/workspace/` holds multiple repos. `cd` into the right clone before any `gh` or `git` command. If the target repo is
ambiguous, ask — never guess. From outside a clone, pass `--repo owner/name`. One repo per command.

Clone into `~/workspace/<owner>/<repo>` mirroring the GitHub path (e.g. `OMGSERVERS/omgserver` →
`~/workspace/OMGSERVERS/omgserver`).

## Branching and PRs

1. Branch off the default — never commit to it directly.
2. Push and open a PR against the default branch with `gh pr create`.
3. Monitor checks to completion (`gh pr checks --watch`); fix failures and address review comments. Never walk away.
4. Squash-merge (`gh pr merge --squash`) only once **all checks pass** and **all review comments are resolved**.
5. If asked to push to the default branch, do it and monitor its workflow runs the same way.
6. Once the PR is merged or the branch has been pushed, check out the default branch and pull remote changes.

See `~/docs/pull-requests.md`.

## Issue tracker

Issues and PRDs live in GitHub Issues for the active repo. Use the `gh` CLI from inside the clone. See
`~/docs/issue-tracker.md`.

## Triage labels

Default label strings: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Per-repo
overrides allowed. See `~/docs/triage-labels.md`.

## Coding standards

### Common

Language-agnostic rules. Apply everywhere.

#### Doc lookup

- Before writing third-party code (any library, framework, SDK, or CLI), verify the API via the `find-docs` skill. Skip
  for own logic and stdlib.

#### Git commits

- Never add Co-Authored-By lines to git commit messages
- Keep commit messages short without any explanations

#### Code style

- No code comments — code must be self-documenting via clear naming, except in tests where comments document intent,
  scenarios, and edge cases

#### Logging levels

- `debug` — diagnostics
- `info` — significant events (state changes, auth)
- `warn` — recoverable issues, edge paths
- `error` — unexpected failures needing attention

### SQL style

- Lowercase everything (tables, columns, keywords)
- `if not exists` guardrails
- Primary keys: `bigint generated always as identity`
- Prefer `not null`
- Timestamps: `timestamp with time zone`
- Opening `(` on the same line as `create table`