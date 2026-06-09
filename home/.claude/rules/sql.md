---
paths:
  - "**/*.sql"
---

# SQL

SQL-specific rules.

## Code style

- Lowercase everything (tables, columns, keywords)
- `if not exists` guardrails
- Primary keys: `bigint generated always as identity`
- Prefer `not null`
- Timestamps: `timestamp with time zone`
- Opening `(` on the same line as `create table`
