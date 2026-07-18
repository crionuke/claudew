# ADR Format

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc. A new ADR takes the
highest existing number plus one. Create the directory lazily — only when the first ADR is needed.

## Shape

An ADR is a decision stated as a title, then 2–4 short labeled sections that describe that decision.

```md
# {The decision, stated as a sentence}

## {Facet}
{1–3 sentences.}

## {Facet}
{1–3 sentences.}
```

A real example:

```md
# Servers scale by replication

## Isolation
Each `Server` is one omgserver process that holds its own state and the long-lived `Player`/`Instance` websocket
connections. A `Server` shares no game state with any other `Server`.

## Scale
Scale and fault tolerance come from running more `Servers`: there is no shared cluster state and no cross-`Server`
coordination.

## Identity
`User` identity is external to a `Server`, so a `User` may roam between `Servers`; an `Instance` does not.
```

When a decision has a single facet, one labeled section — or a single short paragraph under the title — is enough.

## Scope

An ADR records exactly one decision. Every section is a facet of that same decision: a facet whose removal leaves the
title still true and complete is a separate decision and belongs in its own ADR.

## Content

An ADR records only the decision, as a directive to follow. State it and its facets in the present tense, as
established fact. No context, rationale, or rejected alternatives — just what must hold. Negative statements are
fine when they are a direct property of the decision (an invariant, a prohibition, a boundary).

A facet states the rule; the code sites that implement it are the code's to show.

Never reference prior or superseded decisions, earlier versions of the ADR, or how the decision evolved. When a
decision changes, rewrite the ADR so it reads as if written from scratch.

## Title

The title states the decision itself as a sentence, in Sentence case. The filename slug mirrors it:
`# Inputs validated at the entrypoint` → `0001-inputs-validated-at-the-entrypoint.md`.

## Sections

Each section is labeled with a single noun (occasionally two words) naming a facet of this specific decision. Pick the
labels that fit the decision at hand. Labels seen in practice, as a sample to draw from: `Boundary`, `Mechanism`,
`Isolation`, `Scale`, `Identity`, `Scope`, `Routing`, `Lifecycle`, `Authorization`, `Contract`.

Each section holds 1–3 sentences of tight prose. An ADR stays within 120 words across all sections, roughly 10–25
lines wrapped at ~120 characters. ADRs are small and dense.

## Currency

An ADR present in the repo is current and binding. There is no status field and no frontmatter. To retire a decision,
delete or rewrite the ADR.
