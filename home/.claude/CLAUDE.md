# CLAUDEW

Applies to every repo under `~/workspace`. Per-repo `CLAUDE.md` wins on conflict.

## Response tone

- Direct, no filler; push back when something's wrong.
- Code first; name trade-offs with a recommendation.

## Working in repos

### Workspace

`~/workspace/` holds multiple repos. `cd` into the right clone before any `gh` or `git` command. If the target repo is
ambiguous, ask — never guess. From outside a clone, pass `--repo owner/name`. One repo per command.

Clone into `~/workspace/<owner>/<repo>` mirroring the GitHub path (e.g. `OMGSERVERS/omgserver` →
`~/workspace/OMGSERVERS/omgserver`).

### Starting a task

- Start a new task from a clean default branch.
- Dirty tree or not on default? Summarize the leftover changes, ask before cleaning.
- Discard only on explicit OK. If refused, ask: commit, stash, or build on top.
- Skip if the changes belong to the current task — that's a continuation.

### Branching and PRs

1. Branch off the default — never commit to it directly.
2. Push and open a PR against the default branch with `gh pr create`. Always show the PR link in your response.
3. Monitor checks to completion (`gh pr checks --watch`); fix failures and address review comments. Never walk away.
4. Squash-merge (`gh pr merge --squash`) only once **all checks pass** and **all review comments are resolved**.
5. If asked to push to the default branch, do it and monitor its workflow runs the same way.
6. Once the PR is merged or the branch has been pushed, check out the default branch and pull remote changes.

See `~/docs/pull-requests.md`.

## Issue tracking

### Tracker

Issues and PRDs live in GitHub Issues for the active repo. Use the `gh` CLI from inside the clone. See
`~/docs/issue-tracker.md`.

### Triage labels

Default label strings: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Per-repo
overrides allowed. See `~/docs/triage-labels.md`.

## Engineering standards

### Doc lookup

- Before writing third-party code (any library, framework, SDK, or CLI), verify the API via the `find-docs` skill. Skip
  for own logic and stdlib.

### Testing

- When writing tests for a Quarkus web service, follow `~/docs/quarkus-testing.md`.

### Git commits

- Never add Co-Authored-By lines to git commit messages
- Keep commit messages short without any explanations

### Code style

- No code comments — code must be self-documenting via clear naming
- Hard-wrap prose in Markdown/text at 120 chars. Don't reflow code, URLs, tables, or fenced blocks.

### Documentation

Applies to all state-describing docs: `CONTEXT.md`, ADRs, `README`, guides, design docs, docs next to code.

- **State the target.** Describe what holds, in the present tense. Negatives are fine as direct properties — an
  invariant, a prohibition, a boundary.
- **No history.** Drop prior versions, past decisions, evolution, and rejected alternatives. Rewrite each revised
  fragment as if written from scratch.
- **ADRs included.** Record the decision as a directive — no context, rationale, or alternatives.
