# Testing a Quarkus web service: black-box flow tests

Reusable testing guidance for any Quarkus HTTP/WS service. The first tier is stack-agnostic principle; the second tier
is the Quarkus binding. A repo keeps only its own bindings in its local `docs/agents/testing.md` and points here.

## Principles

Hold these regardless of stack or transport.

- **Black box only.** Tests verify the system through the surfaces real clients use, never by reaching inside it. A test
  does not inject production services, touch the database, or trigger a scheduler or job directly.
- **One facade.** A test reaches the system through a single `Tester` facade and nothing else. Only the test-support
  package may reach production code; test classes use `Tester` and the wrappers it exposes.
- **Preconditions through a fluent `TestData` chain.** State is built by a fluent chain that creates each dependency by
  calling the real surfaces, never by service or database calls. Each step auto-creates the dependencies it needs and is
  keyed by a slug (default `"default"`) so several entities coexist in one chain.
- **Each test reads as a story.** The method name is the user story in snake_case, written in the project's glossary
  vocabulary.
- **Assertions scoped to a created id.** Every assertion targets an id the test created — a created entity id or a token
  `sub` — never a global list or count. This keeps tests independent without per-test database cleanup.
- **Wait on product-visible state.** The `TestData` chain owns the async waits; tests observe outcomes by polling
  product-visible state and never invoke a scheduler or job by hand.
- **Negative cases assert on the status code.** A rejection is asserted on the returned status (HTTP code, exit code),
  not on an exception type or a log line.
- **Prefer product surfaces.** An outcome is asserted through a product endpoint whenever one exists. Falling back to an
  admin or diagnostic surface is reserved for a state change with no product-visible projection, and signals a missing
  read surface.

## Quarkus HTTP/WS service binding

These bind the principles above to a Quarkus service tested over HTTP and WebSocket.

- **`@QuarkusTest` with an injected `Tester`.** The suite runs under `@QuarkusTest`; `Tester` is a CDI bean injected with
  `@Inject`. Only the `*.tester.*` package may `@Inject` production code.
- **Server and tester share one `*Api` interface.** Each HTTP entrypoint exposes a JAX-RS `*Api` interface carrying its
  `@Path`, verb, and validation annotations. The production resource implements it; the tester reaches the same surface
  through a Quarkus REST Client bound to that identical interface, so path and request/response shape are declared once.
- **Typed response vs status.** A happy-path actor method returns the typed response DTO. A `...Status(...)` method
  returns the HTTP status as an `int`, asserted with `assertEquals(<code>, tester.<actor>().<...>Status(...))`.
- **Dev Services make the suite self-contained.** Quarkus Dev Services start the backing services (Postgres, Keycloak,
  and the like) on random ports per run, so the suite needs only a working Docker daemon and parallel runs on one host
  coexist because each picks its own ports.
- **Pre-seeded auth users.** Authentication uses fixed users imported into realms. The slug passed to the chain or a
  token helper is the identity username — the mapping is identity. Pick distinct users when a test needs two actors of
  the same kind whose isolation matters; use the default otherwise.

## A flow test

Inject only `Tester`, build preconditions through the fluent `TestData` chain, act through an actor surface, and assert
on the response.

```java
@QuarkusTest
class CreateResourceTest {

    @Inject
    Tester tester;

    @Test
    void a_resource_is_404_until_its_parent_is_published() {
        final var data = tester.data().withAccount().withProject();

        assertEquals(
                404,
                tester.client().getResourceStatus(data.getAccountToken(), data.getProjectSlug()));
    }
}
```

## What stays in the project

Each repo keeps a thin `docs/agents/testing.md` that points here and records only its own bindings: the domain
vocabulary used in test names, the package layout, the concrete `with<Entity>()` chain steps and actor wrappers, the
auth-user table, and any project-specific diagnostic fallback.
