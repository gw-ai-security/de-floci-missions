#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
failures=0
warnings=0
result() { printf '[%s] %s%s\n' "$1" "$2" "${3:+: $3}"; [[ "$1" == FAIL ]] && failures=$((failures+1)); [[ "$1" == WARN ]] && warnings=$((warnings+1)); }

if info=$(docker info --format '{{.OSType}}|{{.Architecture}}|{{.MemTotal}}' 2>/dev/null); then
  IFS='|' read -r os arch memory <<<"$info"
  result PASS "Docker Engine" "$os/$arch"
  [[ "$os" == linux ]] && result PASS "Linux Containers" || result FAIL "Linux Containers" "Linux engine required"
  (( memory < 6442450944 )) && result WARN "Docker RAM" "less than 6 GB" || result PASS "Docker RAM"
else result FAIL "Docker Engine" "not reachable"; fi
docker compose version >/dev/null 2>&1 && result PASS "Docker Compose v2" || result FAIL "Docker Compose v2"
[[ -f .env ]] && result PASS ".env" || result WARN ".env" "copy .env.example"
[[ -f content/DEA-C01_Floci_Hands-on_Missionenplan.md ]] && result PASS "Mission plan" || result FAIL "Mission plan"
docker compose config --quiet >/dev/null 2>&1 && result PASS "Compose configuration" || result FAIL "Compose configuration"
curl -fsS --max-time 2 http://127.0.0.1:4566/_floci/health >/dev/null 2>&1 && result PASS "Floci Health" || result WARN "Floci Health" "core not started"
curl -fsS --max-time 2 http://127.0.0.1:4500/ >/dev/null 2>&1 && result PASS "Floci UI" || result WARN "Floci UI" "not reachable"
curl -fsS --max-time 2 http://127.0.0.1:3000/api/health | grep -q '"missionCount":44' && result PASS "Mission Tracker" "44 missions" || result WARN "Mission Tracker" "not reachable"
printf '\nResult: %d failures, %d warnings\n' "$failures" "$warnings"
(( failures == 0 ))
