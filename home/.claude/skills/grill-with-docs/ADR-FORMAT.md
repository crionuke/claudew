# ADR Format

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc. A new ADR takes the
highest existing number plus one. Create the directory lazily — only when the first ADR is needed.

## Shape

An ADR is a decision stated as a title, then a single short paragraph of 1–3 sentences describing it. No sections,
no frontmatter; 60 words at most. ADRs are small and dense.

```md
# {The decision, stated as a sentence}

{1–3 sentences.}
```

A real example:

```md
# Servers scale by replication

Each `Server` is one omgserver process that holds its own state and the long-lived `Player`/`Instance` websocket
connections; no game state is shared between `Servers`. Scale and fault tolerance come from running more `Servers`.
`User` identity is external to a `Server`, so a `User` may roam between `Servers`; an `Instance` does not.
```

## Scope

An ADR records exactly one decision. A sentence whose removal leaves the title still true and complete records a
separate decision and belongs in its own ADR.

## What qualifies

- Architectural shape: the structural pattern of the system — monorepo, event-sourced write model, projected read
  model.
- Integration patterns between contexts: how contexts talk — domain events, synchronous HTTP, shared storage.
- Technology choices that carry lock-in: database, message bus, auth provider, deployment target — the ones that
  take a quarter to swap out, not every library.
- Boundary and scope decisions: who owns what data, who may reference it, and how; explicit prohibitions count as
  much as permissions.
- Constraints not visible in the code: compliance limits, contractual latency budgets, platform restrictions.

## Content

An ADR records only the decision, as a directive to follow. State it in the present tense, as established fact. No
context, rationale, or rejected alternatives — just what must hold. Negative statements are fine when they are a
direct property of the decision (an invariant, a prohibition, a boundary).

The ADR states the rule; the code sites that implement it are the code's to show.

Never reference prior or superseded decisions, earlier versions of the ADR, or how the decision evolved. When a
decision changes, rewrite the ADR so it reads as if written from scratch.

## Title

The title states the decision itself as a sentence, in Sentence case. The filename slug mirrors it:
`# Inputs validated at the entrypoint` → `0001-inputs-validated-at-the-entrypoint.md`.

## Currency

An ADR present in the repo is current and binding. There is no status field. To retire a decision, delete or
rewrite the ADR.
