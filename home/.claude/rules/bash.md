---
paths:
  - "**/*.sh"
  - "**/*.bash"
---

# Bash

Bash-specific rules.

## Code style

- `UPPER_CAPITAL` identifiers for variables (e.g. `SOURCE_DIR`, `EXIT_CODE`)
- Quote expansions: `"${VAR}"`, not `$VAR`
- `set -euo pipefail` at the top of every script
- `[[ ... ]]` over `[ ... ]` for tests
- `local` for function variables
