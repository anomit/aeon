#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

COUNT=$(jq '.alerts | length' .bds-cache/alerts.json)
echo "Dispatching $COUNT alerts..."
for i in $(seq 0 $((COUNT - 1))); do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  ./notify "$ALERT"
  echo "  Alert $((i + 1))/$COUNT dispatched"
done
echo "Done. All $COUNT alerts dispatched."
