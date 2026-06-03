# Triage labels

Skills speak in terms of five canonical triage roles. Each repo may use different label strings — this file is the
workspace-wide default. Override per repo by placing a `triage-labels.md` next to that repo's `CLAUDE.md`; the
per-repo file wins.

| Canonical role    | Default label string | Meaning                                  |
|-------------------|----------------------|------------------------------------------|
| `needs-triage`    | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`      | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent` | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human` | `ready-for-human`    | Requires human implementation            |
| `wontfix`         | `wontfix`            | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), look up the corresponding label string for the
active repo (per-repo override if present, otherwise this default), then run `gh issue edit <n> --add-label "<string>"`
from inside that repo's clone.

Before applying a label for the first time in a repo, confirm it exists with `gh label list`. Create it with
`gh label create "<name>"` if missing — do not silently fall back to a similar-looking label.
