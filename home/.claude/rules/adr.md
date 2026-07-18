---
paths:
  - "**/docs/adr/*.md"
---

# ADR

Rules for architecture decision records.

## Title

- The title states the decision itself as a sentence, in Sentence case.
- The filename slug mirrors the title: `# Inputs validated at the entrypoint` →
  `0001-inputs-validated-at-the-entrypoint.md`.

## Shape

- The body is a single paragraph of 1–3 sentences, at most 60 words — no sections, no frontmatter.

## Scope

- An ADR records exactly one decision: every sentence is required for the title to hold. A sentence whose removal
  leaves the title still true and complete belongs in its own ADR.

## Content

- The body states the rule in the present tense, as established fact, directive to follow.
- Every sentence states the rule itself; mechanics the code shows stay in the code.
- The body reads as written from scratch — free of references to prior or superseded decisions, rationale, or
  alternatives.
