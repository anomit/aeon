#!/usr/bin/env bash
# Dispatch all alerts from .bds-cache/alerts.json via ./notify
set -e

ALERTS_FILE=".bds-cache/alerts.json"
COUNT=0
TOTAL=$(jq '.alerts | length' "$ALERTS_FILE")

for i in $(seq 0 $((TOTAL - 1))); do
  ALERT=$(jq -r ".alerts[$i]" "$ALERTS_FILE")
  ./notify "$ALERT"
  COUNT=$((COUNT + 1))
done

echo "Sent $COUNT/$TOTAL alerts"
