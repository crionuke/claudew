# CLAUDEW

A setup for running several isolated Claude Code instances in parallel, each in its own Docker sandbox.

## Language

**Agent**:
A running Claude Code instance — the actor that does the work inside a worker. Use this word in user-facing copy when talking about who performs a task.
_Avoid_: bot, assistant

**Worker**:
The infrastructure unit that hosts one agent: a Docker service (`worker_a`/`worker_b`/`worker_c`) with its own isolated volume and identity.
_Avoid_: container (too generic), instance

**Session**:
A single interactive run of `claudew` inside a worker — one terminal attached to one agent.
_Avoid_: tab, window
