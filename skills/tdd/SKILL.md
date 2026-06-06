---
name: tdd
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

**No mocks.** Run against real collaborators — real test DB, real local services (e.g. via compose), real time where feasible. Never mock your own classes, internal collaborators, or anything you control (including your own DB). A mock is a last resort for a true external boundary you cannot stand up locally (third-party billing/email/push); justify each one. Reaching for a mock usually means you're testing implementation, not behavior.

**Unit tests are the exception, not the driver.** Design is driven outside-in by behavior tests through the public interface — not by making internal classes unit-testable. A fine-grained unit test is earned post-hoc, only for a stateless algorithmic class whose behavior is fully determined by its arguments; it recognizes a clean algorithm that emerged, it does not shape the design.

**Good vs bad, concretely:**

- Good: tests behavior a caller cares about · uses the public API only · survives internal refactors · describes WHAT, not HOW · one logical assertion per test.
- Red flags: testing private methods · asserting on call counts or call order · verifying through a side channel (reading the DB directly) instead of the interface · a name that describes HOW, not WHAT.
- The side-channel fix: assert through the same surface a caller uses — create via the API, read it back via the API. If a behavior can only be checked through a side channel, the public interface is probably missing a read surface.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test _imagined_ behavior, not _actual_ behavior
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### 1. Planning

When exploring the codebase, use the project's domain glossary so that test names and interface vocabulary match the project's language, and respect ADRs in the area you're touching.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for deep modules — small interface, deep implementation (see Design for testability)
- [ ] Design interfaces for testability (see Design for testability)
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Tracer Bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This is your tracer bullet - proves the path works end-to-end.

### 3. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for refactor candidates:

- **Duplication** → extract function/class
- **Long methods** → break into private helpers (keep tests on the public interface)
- **Shallow modules** → combine or deepen
- **Feature envy** → move logic to where the data lives
- **Primitive obsession** → introduce value objects
- **Existing code** the new code reveals as problematic
- Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Design for testability

**Deep modules** — a small interface over a lot of implementation. Hide complexity behind a narrow surface; avoid shallow modules (large interface, thin pass-through implementation that just delegates). When designing an interface, ask: can I reduce the number of methods? simplify the parameters? hide more complexity inside?

**Interface design:**

- **Accept dependencies, don't create them** — pass collaborators in rather than constructing them internally. Injected real collaborators keep the unit composable (this is not about mocking — see Philosophy).
- **Prefer returning results over side effects** — a function that returns a value is easier to verify than one that mutates hidden state.
- **Small surface area** — fewer methods and fewer parameters mean fewer tests and simpler setup.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
