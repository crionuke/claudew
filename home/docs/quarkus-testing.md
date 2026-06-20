# Quarkus Testing

Reusable testing guidance for any Quarkus web service: principles first, then the Quarkus binding.

## The harness

Two test-support types carry every test; a test depends on nothing else.

- **`Tester`** — the single entry point a test injects. It exposes the `TestData` builder, a set of action wrappers that
  call the system's public surfaces as a given role, and auth/token helpers. Every interaction with the system goes
  through it.
- **`TestData`** — a fluent builder, reached via `tester.data()`, that provisions the entities a test needs by calling
  those same public surfaces, never the database. It auto-creates each dependency, keys every entity by a handle
  (default `"default"`) so several coexist in one test, remembers the ids and tokens it minted so assertions can target
  them, and owns the async waits that poll product-visible state.

## Principles

- **Black box.** Drive the system only through the surfaces real clients use — never inject production services, touch
  the database, or trigger schedulers.
- **Tests as stories.** Name each method as the user story in snake_case, in the project's domain vocabulary.
- **Scoped assertions.** Assert on an id the test created, never a global list or count, so tests stay independent
  without cleanup.
- **Product-visible waits.** Wait through `TestData` on product state; never invoke a job by hand.
- **Reject on status.** Assert negative cases on the returned status code.
- **Product surfaces first.** Fall back to a diagnostic surface only when no product surface exposes the change.

## Quarkus binding

- `@QuarkusTest` with an injected `Tester` CDI bean; only the test-support package may `@Inject` production code.
- Server and tester share one JAX-RS `*Api` interface — the resource implements it, the tester calls it via REST Client.
- A happy-path method returns the typed DTO; a `...Status(...)` method returns the HTTP status as an `int`.
- Dev Services start backing services on random ports, so the suite needs only Docker and parallel runs coexist.
- Authentication uses fixed pre-seeded users; a builder step takes the username to act as. Pick distinct users for
  isolation tests.

## A flow test

A test injects only `Tester`, builds preconditions through the `TestData` chain, calls a public surface as the chosen
role, and asserts on the response:

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
                tester.client().getResourceStatus(data.getAccountToken(), data.getProjectId()));
    }
}
```
