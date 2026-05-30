#!/bin/bash
set -e
cd /home/runner/work/aeon/aeon
COUNT=$(jq '.alerts | length' .bds-cache/alerts.json)
i=0
while [ "$i" -lt "$COUNT" ]; do
  alert=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
  ./notify "$alert"
  i=$((i + 1))
done
echo "Dispatched $COUNT alerts"
