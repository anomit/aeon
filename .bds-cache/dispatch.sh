#!/usr/bin/env bash
set -euo pipefail
mkdir -p .pending-notify

# Read alerts from JSON and write to pending-notify for post-run delivery
python3 -c '
import json, time, os
with open(".bds-cache/alerts.json") as f:
    data = json.load(f)
os.makedirs(".pending-notify", exist_ok=True)
for alert in data["alerts"]:
    ts = str(int(time.time() * 1000))
    with open(f".pending-notify/{ts}.md", "w") as out:
        out.write(alert)
    print(f"wrote alert to .pending-notify/{ts}.md")
print(f"total: {len(data[\"alerts\"])}")
'
