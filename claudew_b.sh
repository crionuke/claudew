#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

docker compose up -d --build claudew_b
exec docker compose exec claudew_b claudew "$@"