#!/bin/bash
cd "$(dirname "$0")/.."
count=$(jq '.alerts | length' .bds-cache/alerts.json)
sent=0
failed=0
i=0
while [ "$i" -lt "$count" ]; do
  alert=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  if ./notify "$alert" 2>/dev/null; then
    sent=$((sent+1))
  else
    failed=$((failed+1))
  fi
  i=$((i+1))
done
echo "Sent: $sent, Failed: $failed"
