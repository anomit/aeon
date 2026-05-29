#!/usr/bin/env bash
# Dispatch BDS alerts from .bds-cache/alerts.json
set -eo pipefail

ALERTS_FILE=".bds-cache/alerts.json"
TOTAL=$(jq '.alerts | length' "$ALERTS_FILE")
SENT=0
FAIL=0

for i in $(seq 0 $((TOTAL - 1))); do
  jq -r ".alerts[$i]" "$ALERTS_FILE" > "/tmp/bds_alert_$i.txt"
  if ./notify "$(cat /tmp/bds_alert_$i.txt)"; then
    SENT=$((SENT + 1))
  else
    FAIL=$((FAIL + 1))
  fi
  rm -f "/tmp/bds_alert_$i.txt"
done

echo "Dispatched: $SENT OK, $FAIL failed, $TOTAL total"
echo "EPOCH_END=$(jq -r '.epoch_end' "$ALERTS_FILE")"
