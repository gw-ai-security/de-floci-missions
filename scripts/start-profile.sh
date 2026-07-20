#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
profile="${1:?usage: start-profile.sh <lab|spark|cdc|airflow|flink|vector|rag|bi|observability|tools>}"
case "$profile" in tools|lab|spark|cdc|airflow|flink|vector|rag|bi|observability) ;; *) echo "Unknown profile: $profile" >&2; exit 2;; esac
[[ -f .env ]] || { echo 'Copy .env.example to .env first.' >&2; exit 1; }
docker compose --profile "$profile" up --build -d
docker compose --profile "$profile" ps
