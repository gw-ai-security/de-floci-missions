#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
profile="${1:-all}"
profiles=(tools lab spark cdc airflow flink vector rag bi observability)
[[ "$profile" == all ]] || profiles=("$profile")
for item in "${profiles[@]}"; do docker compose --profile "$item" config --quiet; echo "[PASS] $item config"; done
