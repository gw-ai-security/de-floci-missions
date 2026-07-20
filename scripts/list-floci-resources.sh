#!/usr/bin/env bash
set -euo pipefail
docker ps -a --filter network=dea_floci_net --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker volume ls --filter label=floci=true
docker ps --filter network=dea_floci_net --format '{{.Names}} {{.Ports}}'
