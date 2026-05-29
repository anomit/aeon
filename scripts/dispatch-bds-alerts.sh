#!/usr/bin/env bash
set -euo pipefail

ALERTS_FILE=".bds-cache/alerts.json"
COUNT=0
TOTAL=$(jq '.alerts | length' "$ALERTS_FILE")

for i in $(seq 0 $((TOTAL - 1))); do
  ALERT=$(jq -r ".alerts[$i]" "$ALERTS_FILE")
  ./notify "$ALERT"
  COUNT=$((COUNT + 1))
done

echo "Dispatched $COUNT alerts out of $TOTAL"
