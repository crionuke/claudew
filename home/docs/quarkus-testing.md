# Quarkus Testing

Reusable testing guidance for any Quarkus web service: principles first, then the Quarkus binding.

## Principles

- **Black box.** Drive the system only through the surfaces real clients use — never inject production services, touch
  the database, or trigger schedulers.
- **One facade.** Tests reach the system through a single `Tester`; only the test-support package touches production code.
- **Fluent preconditions.** Build state through a fluent `TestData` chain that calls the real surfaces, keyed by a slug
  (default `"default"`).
- **Tests as stories.** Name each method as the user story in snake_case, in the project's glossary vocabulary.
- **Scoped assertions.** Assert on an id the test created, never a global list or count, so tests stay independent
  without cleanup.
- **Product-visible waits.** Observe outcomes by polling product state through `TestData`; never invoke a job by hand.
- **Reject on status.** Assert negative cases on the returned status code.
- **Product surfaces first.** Fall back to an admin surface only when no product-visible projection exists.

## Quarkus binding

- `@QuarkusTest` with an injected `Tester` CDI bean; only the `*.tester.*` package may `@Inject` production code.
- Server and tester share one JAX-RS `*Api` interface — the resource implements it, the tester calls it via REST Client.
- A happy-path method returns the typed DTO; a `...Status(...)` method returns the HTTP status as an `int`.
- Dev Services start backing services on random ports, so the suite needs only Docker and parallel runs coexist.
- Authentication uses fixed pre-seeded users; the passed slug is the username. Pick distinct users for isolation tests.

## A flow test

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
