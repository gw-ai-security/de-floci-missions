#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
if [[ ! -f .env ]]; then cp .env.example .env; echo '[WARN] Created .env; change profile passwords before use.'; fi
"$PWD/scripts/doctor.sh"
docker compose up --build -d
printf 'Mission Tracker: http://localhost:3000\nFloci UI: http://localhost:4500\nFloci API: http://localhost:4566\n'
