# Issue tracker: GitHub

Issues and PRDs live as GitHub issues in whichever repo you are working in. Use the `gh` CLI for all operations.

`gh` infers the repo from the current working tree's `git remote -v` — always run it from inside the relevant clone
under `~/workspace/<repo>/`. If you must operate from outside a clone, pass `--repo owner/name` explicitly. Never let
one command span two repos.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

## When a skill says "publish to the issue tracker"

Create a GitHub issue in the active repo.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments` from inside the relevant clone (or with `--repo owner/name`).
