---
name: get-shipped
description: Collect merged pull requests across all ~/workspace repos for a period (default today) and write a narrative summary of what shipped. Use when the user asks "what shipped", "what got merged", "what was done", "summary of work", a standup/daily/weekly report, or progress across projects for a day, yesterday, a week, or a date range.
---

# get-shipped

Gather **merged PRs (all authors)** across every repo under `~/workspace`, then compose a
human-readable summary of what was shipped. The script produces the raw log; you write the narrative.

## Quick start

Run the bundled script (defaults to **today**) and summarize its output:

```bash
bash ~/.claude/skills/get-shipped/scripts/get-shipped.sh
```

Other periods and repo filters:

```bash
get-shipped.sh yesterday              # merged yesterday
get-shipped.sh 7d                     # last 7 days   (also: week, 30d, month)
get-shipped.sh 2026-06-01             # a single day
get-shipped.sh 2026-06-01..2026-06-07 # an explicit range
get-shipped.sh 7d omgserver claudew   # period + path-substring repo filters
```

## What the script emits

- A `period:` header with the resolved date range.
- One `## <owner>/<repo>  (N merged)` section per repo that had merges, each PR as a tab-separated
  line: `#num  date  @author  title  url`.
- Repos with no GitHub remote / no `gh` access are reported as `SKIP`.
- A final `done: X merged PRs across Y/Z repos, S skipped` line.

## Composing the summary

After running, write a summary for the user:

- Lead with the period and totals (`X PRs across Y repos`).
- One section per repo that had activity; drop repos with zero merges.
- Group related PRs into themes rather than listing every title verbatim — describe the work done,
  not just the changelog. Keep PR `#num` references so items stay traceable.
- Call out anything notable (a feature shipped, a refactor, a fix) over trivial doc/typo churn.
- If repos were skipped, name them so the user knows coverage was partial.

## Notes

- Source is **merged PRs only** — local commits and uncommitted work are not included by design.
- `gh` must be authenticated; the script runs `gh pr list` from inside each clone.
- Period keywords and dates use the host's local date.
