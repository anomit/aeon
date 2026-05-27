#!/usr/bin/env bash
set -euo pipefail
# Save BDS alerts to .pending-notify/ for post-run delivery
mkdir -p .pending-notify
TS=$(date -u +%s)
INDEX=0
jq -r '.alerts[]' .bds-cache/alerts.json | while read -r alert; do
  echo "$alert" > ".pending-notify/${TS}-${INDEX}.md"
  INDEX=$((INDEX + 1))
done
COUNT=$(jq '.alerts | length' .bds-cache/alerts.json)
echo "Saved ${COUNT} alerts to .pending-notify/"
