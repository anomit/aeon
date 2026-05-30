#!/usr/bin/env bash
set -euo pipefail
COUNT=0
TOTAL=$(jq '.alerts | length' .bds-cache/alerts.json)
for i in $(seq 0 $((TOTAL - 1))); do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  ./notify "$ALERT" && COUNT=$((COUNT + 1)) || true
done
echo "Dispatched ${COUNT}/${TOTAL} alerts"
