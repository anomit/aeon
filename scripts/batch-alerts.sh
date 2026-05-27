#!/usr/bin/env bash
set -euo pipefail
TOTAL=$(jq '.alerts | length' .bds-cache/alerts.json)
i=0
while [ "$i" -lt "$TOTAL" ]; do
  jq -r ".alerts[$i]" .bds-cache/alerts.json > ".pending-notify/1779888$(printf '%03d' "$i").md"
  i=$((i + 1))
done
echo "Wrote $TOTAL alert files to .pending-notify/"
