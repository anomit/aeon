#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

for i in 1 2 3 4 5 6 7 8 9; do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  ./notify "$ALERT"
  echo "Alert $i: dispatched (exit $?)"
done
