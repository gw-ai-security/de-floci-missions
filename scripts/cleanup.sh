#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
"$PWD/scripts/reset.sh" "${1:-}"
mapfile -t images < <(docker images --filter reference='dea-floci/*' --format '{{.Repository}}:{{.Tag}}')
if ((${#images[@]})); then docker image rm "${images[@]}"; fi
