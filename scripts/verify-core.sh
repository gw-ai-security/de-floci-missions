#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
wait_http() { for _ in $(seq 1 45); do curl -fsS --max-time 3 "$1" && return; sleep 2; done; return 1; }
wait_http http://127.0.0.1:4566/_floci/health >/dev/null && echo '[PASS] Floci health'
wait_http http://127.0.0.1:3000/api/health | grep -q '"missionCount":44' && echo '[PASS] Mission Tracker'
curl -fsS http://127.0.0.1:4500/ >/dev/null && echo '[PASS] Floci UI'
docker compose exec -T floci awslocal sts get-caller-identity >/dev/null && echo '[PASS] AWS CLI / STS'
bucket="smoke-core-$(date +%s)-$RANDOM"
cleanup() { docker compose exec -T floci awslocal s3 rm "s3://$bucket/smoke.txt" >/dev/null 2>&1 || true; docker compose exec -T floci awslocal s3api delete-bucket --bucket "$bucket" >/dev/null 2>&1 || true; }
trap cleanup EXIT
docker compose exec -T floci awslocal s3api create-bucket --bucket "$bucket" --create-bucket-configuration LocationConstraint=eu-central-1 >/dev/null
printf northstar-smoke | docker compose exec -T floci sh -c 'cat >/tmp/smoke.txt'
docker compose exec -T floci awslocal s3 cp /tmp/smoke.txt "s3://$bucket/smoke.txt" >/dev/null
docker compose exec -T floci awslocal s3api head-object --bucket "$bucket" --key smoke.txt >/dev/null && echo '[PASS] S3 write/read'
cleanup; trap - EXIT
echo '[PASS] S3 cleanup'
