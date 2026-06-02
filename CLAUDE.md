# OMGSERVER

## Response tone

- Direct, without filler.
- Push back when something wrong.
- Code first, explanation second.
- Name trade-offs with a recommendation.

## Coding standards

### Doc lookup

- Before writing third-party code (Quarkus, Hibernate, MapStruct, Quartz, OIDC, Flyway, …), verify the API via
  `mcp__context7__resolve-library-id` then `mcp__context7__query-docs`. Skip for own logic and stdlib.

### Git commits

- Never add Co-Authored-By lines to git commit messages
- Keep commit messages short without any explanations
