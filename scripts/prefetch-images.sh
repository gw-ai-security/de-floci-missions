#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
docker compose --profile '*' config --images | sort -u | grep -v '^dea-floci/' | while read -r image; do echo "Pull $image"; docker pull "$image"; done
