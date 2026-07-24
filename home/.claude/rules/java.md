---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/application*.yaml"
---

# Java

Java-specific rules.

## Code style

### Naming

- Short class field names when the type disambiguates: `PlayerService players`, not `playerService`
- Plural only for a service over many entities; a single-instance component stays singular: `SessionAssigner
  sessionAssigner`, not `sessionAssigners`
- `find` is a repository-level verb: only a `*Repository` names methods `find*`
- Above the repository, a read is `get`/`list`: `get` returns at most one as `Optional`, `getRequired` returns one or
  throws, `list` returns many
- A store method omits the entity when its class already names it: `games.getBySlug(slug)`, not
  `games.getGameBySlug(slug)`. A facade over many entities keeps it: `catalog.getGameBySlug(slug)`
- `require*` is a guard that returns nothing; a read that throws when absent is `getRequired*`
- `Dto` suffix for inter-layer carriers; `Request`/`Response` for HTTP bodies. Endpoint scope lives in the package.
- `Spec` suffix for transient creation payloads passed to `service.create(...)`. `Config` suffix for developer-supplied
  JSON blobs persisted on an entity (JSONB column).

### Language

- Initialize fields in constructors, not inline
- `final var` for local variables, `final` for method arguments and class fields
- Java Stream API over `for`/`while` loops for collection iteration and transformation

### Logging

- When logging a caught exception via `log.warn`/`log.error`, put its message in the log line, not just the stack
  trace, so it stays greppable.

## Lombok

- `@AllArgsConstructor` + `private final` fields for constructor injection. No `@Inject` on fields
- `@Slf4j` for logging with parameterized messages: `log.info("Message with value {}", value)`

## Quarkus

### Components

- `@ApplicationScoped` on services and repositories

### Config

- Manage Quarkus deps via the CLI (`quarkus ext add …`, `quarkus dev`, `quarkus build`), not by editing `pom.xml`.
- Profile config in `application-{profile}.yaml` files (e.g. `application-dev.yaml`), not inline `%dev`/`%test` keys.
- Read config via `@ConfigMapping`, not `@ConfigProperty`. Keep defaults in the yaml, not in `@WithDefault`.
