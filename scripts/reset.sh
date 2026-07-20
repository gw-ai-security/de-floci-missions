#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
force="${1:-}"
docker ps -a --filter network=dea_floci_net --format '  {{.ID}} {{.Names}}'
docker volume ls --filter label=com.docker.compose.project=dea-floci-missions --format '  {{.Name}}'
if [[ "$force" != --force ]]; then read -r -p 'Delete all project mission/profile data? [y/N] ' answer; [[ "$answer" =~ ^[Yy]$ ]] || exit 0; fi
docker compose --profile '*' down --volumes --remove-orphans
echo 'Project state reset; unrelated Docker projects were not changed.'
