#!/usr/bin/env bash
set -euo pipefail
COUNT=$(jq -r '.alerts | length' .bds-cache/alerts.json)
SENT=0
SKIPPED=0
for i in $(seq 0 $((COUNT - 1))); do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  RESULT=$(./notify "$ALERT" 2>&1) || true
  if echo "$RESULT" | grep -q "duplicate\|suppressing"; then
    SKIPPED=$((SKIPPED + 1))
    echo "  [$((i+1))/$COUNT] skipped"
  else
    SENT=$((SENT + 1))
    echo "  [$((i+1))/$COUNT] sent"
  fi
done
echo ""
echo "Total: $COUNT alerts, $SENT sent, $SKIPPED skipped"
