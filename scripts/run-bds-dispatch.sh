#!/usr/bin/env bash
set -euo pipefail
# Dispatch all cached BDS alerts via ./notify
cd "$(dirname "$0")/.."
TOTAL=0
SENT=0
DUP=0
FAIL=0

# Read alert count
COUNT=$(jq '.alerts | length' .bds-cache/alerts.json)
echo "Dispatching $COUNT alerts..."

for i in $(seq 0 $((COUNT - 1))); do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  TOTAL=$((TOTAL + 1))
  OUTPUT=$(./notify "$ALERT" 2>&1) && RC=$? || RC=$?
  if echo "$OUTPUT" | grep -q "duplicate"; then
    DUP=$((DUP + 1))
  elif [ "$RC" -eq 0 ]; then
    SENT=$((SENT + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL [$i]: $OUTPUT" >&2
  fi
done

echo "Done: sent=$SENT dup=$DUP fail=$FAIL total=$TOTAL"
