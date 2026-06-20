# CLAUDEW

Applies to every repo under `~/workspace`. Per-repo `CLAUDE.md` wins on conflict.

## Response tone

- Direct, no filler; push back when something's wrong.
- Code first; name trade-offs with a recommendation.

## Where you are

`~/workspace/` holds multiple repos. `cd` into the right clone before any `gh` or `git` command. If the target repo is
ambiguous, ask — never guess. From outside a clone, pass `--repo owner/name`. One repo per command.

Clone into `~/workspace/<owner>/<repo>` mirroring the GitHub path (e.g. `OMGSERVERS/omgserver` →
`~/workspace/OMGSERVERS/omgserver`).

## Starting a task

- Start a new task from a clean default branch.
- Dirty tree or not on default? Summarize the leftover changes, ask before cleaning.
- Discard only on explicit OK. If refused, ask: commit, stash, or build on top.
- Skip if the changes belong to the current task — that's a continuation.

## Branching and PRs

1. Branch off the default — never commit to it directly.
2. Push and open a PR against the default branch with `gh pr create`. Always show the PR link in your response.
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

- No code comments — code must be self-documenting via clear naming
- Hard-wrap prose in Markdown/text at 120 chars. Don't reflow code, URLs, tables, or fenced blocks.

## Documentation

Applies to all state-describing docs: `CONTEXT.md`, ADRs, `README`, guides, design docs, and docs next to code.

- **Document the target state.** Describe what must hold, in the present tense, as established fact. Negative
  statements are fine when they are a direct property of that state (an invariant, a prohibition, a boundary).
- **No history, no back-references.** Don't reference prior or overwritten versions, decisions, or the document's
  evolution, and don't justify anything through rejected alternatives ("previously", "instead of the old approach",
  "as decided in #N"). When revising a fragment, rewrite it so it reads as if written from scratch.
- ADRs follow this too: record only the decision as a directive to follow — no context, rationale, or alternatives.