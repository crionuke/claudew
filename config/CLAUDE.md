# CLAUDEW

Applies to every repo under `~/workspace`. Per-repo `CLAUDE.md` wins on conflict.

## Response tone

- Direct, without filler.
- Push back when something wrong.
- Code first, explanation second.
- Name trade-offs with a recommendation.

## Where you are

`~/workspace/` holds multiple repos. `cd` into the right clone before any `gh` or `git` command. If the target repo is
ambiguous, ask — never guess. From outside a clone, pass `--repo owner/name`. One repo per command.

## Branching and PRs

1. Branch off the default — never commit to it directly.
2. Push and open a PR against the default branch with `gh pr create`, then enable squash auto-merge
   (`gh pr merge --squash --auto`).
3. Monitor checks to completion (`gh pr checks --watch`); fix failures and address review comments. Never walk away.
4. If asked to push to the default branch, do it and monitor its workflow runs the same way.

See `~/workspace/pull-requests.md`.

### Issue tracker

Issues and PRDs live in GitHub Issues for the active repo. Use the `gh` CLI from inside the clone. See
`~/workspace/issue-tracker.md`.

### Triage labels

Default label strings: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Per-repo
overrides allowed. See `~/workspace/triage-labels.md`.

## Coding standards

### Doc lookup

- Before writing third-party code (Quarkus, Hibernate, MapStruct, Quartz, OIDC, Flyway, …), verify the API via the
  `find-docs` skill. Skip for own logic and stdlib.

### Git commits

- Never add Co-Authored-By lines to git commit messages
- Keep commit messages short without any explanations

### Quarkus config

- Manage Quarkus deps via the CLI (`quarkus ext add …`, `quarkus dev`, `quarkus build`), not by editing `pom.xml`.
- Profile config in `application-{profile}.yaml` files (e.g. `application-dev.yaml`), not inline `%dev`/`%test` keys.
- Read config via `@ConfigMapping`, not `@ConfigProperty`. Keep defaults in the yaml, not in`@WithDefault`.

### Code style

- Initialize fields in constructors, not inline
- `final var` for local variables, `final` for method arguments and class fields
- Short variable names when unambiguous: `PlayerService players`, not `playerService`
- Parameterized logging: `log.info("Message with value {}", value)`
- Java Stream API over `for`/`while` loops for collection iteration and transformation
- `@ApplicationScoped` on services and repositories (Jakarta)
- `Dto` suffix for inter-layer carriers; `Request`/`Response` for HTTP bodies. Endpoint scope lives in the package.
- `Spec` suffix for transient creation payloads passed to `service.create(...)`. `Config` suffix for developer-supplied
  JSON blobs persisted on an entity (JSONB column).

### Lombok usage

- `@AllArgsConstructor` + `private final` fields for constructor injection (Lombok). No `@Inject` on fields
- `@Slf4j` for logging (Lombok)

### SQL style

- Lowercase everything (tables, columns, keywords)
- `if not exists` guardrails
- Primary keys: `bigint generated always as identity`
- Prefer `not null`
- Timestamps: `timestamp with time zone`
- Opening `(` on the same line as `create table`

### Logging levels

- `debug` — diagnostics
- `info` — significant events (state changes, auth)
- `warn` — recoverable issues, edge paths
- `error` — unexpected failures needing attention