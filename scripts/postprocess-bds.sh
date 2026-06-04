#!/bin/bash
# Post-process BDS skill: backup cursor + dispatch alerts (LLM often skips ./notify).

set -e

STATE_FILE="memory/powerloom-bds-state.json"
EPOCH_FILE=".bds-cache/epoch_range.txt"

if [ -f "$EPOCH_FILE" ]; then
  EPOCH_END=$(sed -n '2p' "$EPOCH_FILE")
  if [ -n "$EPOCH_END" ]; then
    python3 << PYTHON
import json
from pathlib import Path

state_path = Path("$STATE_FILE")
epoch_end = int("$EPOCH_END")

state = {}
if state_path.is_file():
    try:
        state = json.loads(state_path.read_text())
    except (OSError, json.JSONDecodeError):
        state = {}

prev = state.get("lastStreamEpoch")
if prev is None or int(prev) < epoch_end:
    state["lastStreamEpoch"] = epoch_end
    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(json.dumps(state, indent=2) + "\n")
    print(f"postprocess-bds: advanced cursor to {epoch_end}")
else:
    print(f"postprocess-bds: cursor already at {prev}")
PYTHON
  else
    echo "postprocess-bds: empty epoch end — skip cursor backup"
  fi
else
  echo "postprocess-bds: no epoch_range.txt — skip cursor backup"
fi

# Dispatch cached alerts via ./notify (requires TELEGRAM_* on post-process workflow env)
ALERTS_FILE=".bds-cache/alerts.json"
if [ ! -f "$ALERTS_FILE" ]; then
  echo "postprocess-bds: no alerts.json — skip dispatch"
  exit 0
fi

if [ ! -x "./notify" ]; then
  echo "postprocess-bds: ./notify missing — skip dispatch (re-run will not duplicate; fingerprints committed)"
  exit 0
fi

ALERT_COUNT=$(jq '.alerts | length' "$ALERTS_FILE" 2>/dev/null || echo 0)
if [ "$ALERT_COUNT" -eq 0 ] 2>/dev/null; then
  echo "postprocess-bds: zero alerts"
  exit 0
fi

echo "postprocess-bds: dispatching $ALERT_COUNT alerts"
for i in $(seq 0 $((ALERT_COUNT - 1))); do
  ALERT=$(jq -r ".alerts[$i]" "$ALERTS_FILE")
  ./notify "$ALERT" || true
done
echo "postprocess-bds: dispatched $ALERT_COUNT alerts"

exit 0
