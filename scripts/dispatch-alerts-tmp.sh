#!/usr/bin/env bash
set -euo pipefail
cd /home/runner/work/aeon/aeon

TOTAL=$(jq '.alerts | length' .bds-cache/alerts.json)
echo "Dispatching $TOTAL alerts..."

for i in $(seq 0 $((TOTAL - 1))); do
  ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  ./notify "$ALERT" && echo "  [$((i+1))/$TOTAL] sent" || echo "  [$((i+1))/$TOTAL] failed"
done

echo "Done. epoch_end: $(jq -r '.epoch_end' .bds-cache/alerts.json)"
