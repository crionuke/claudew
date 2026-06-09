---
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/application*.yaml"
---

# Java

Java-specific rules.

## Code style

- Initialize fields in constructors, not inline
- `final var` for local variables, `final` for method arguments and class fields
- Short class field names when the type disambiguates: `PlayerService players`, not `playerService`
- Getter-style service methods: `players.getPlayer(id)`, not `players.player(id)`
- Java Stream API over `for`/`while` loops for collection iteration and transformation
- `@ApplicationScoped` on services and repositories
- `Dto` suffix for inter-layer carriers; `Request`/`Response` for HTTP bodies. Endpoint scope lives in the package.
- `Spec` suffix for transient creation payloads passed to `service.create(...)`. `Config` suffix for developer-supplied
  JSON blobs persisted on an entity (JSONB column).

## Lombok

- `@AllArgsConstructor` + `private final` fields for constructor injection. No `@Inject` on fields
- `@Slf4j` for logging with parameterized messages: `log.info("Message with value {}", value)`

## Quarkus config

- Manage Quarkus deps via the CLI (`quarkus ext add …`, `quarkus dev`, `quarkus build`), not by editing `pom.xml`.
- Profile config in `application-{profile}.yaml` files (e.g. `application-dev.yaml`), not inline `%dev`/`%test` keys.
- Read config via `@ConfigMapping`, not `@ConfigProperty`. Keep defaults in the yaml, not in `@WithDefault`.