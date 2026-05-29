#!/usr/bin/env bash
set -euo pipefail
cd /home/runner/work/aeon/aeon

# Dispatch BDS alerts from cached JSON via Python (avoids shell expansion issues with $ in alerts)
python3 << 'PYEOF'
import json, subprocess, sys, os

os.chdir("/home/runner/work/aeon/aeon")

with open(".bds-cache/alerts.json") as f:
    data = json.load(f)

alerts = data.get("alerts", [])
sent = 0
skipped = 0

for i, alert in enumerate(alerts):
    result = subprocess.run(
        ["./notify", alert],
        capture_output=True, text=True
    )
    if result.returncode == 0:
        out = result.stdout.strip() or result.stderr.strip() or ""
        if "duplicate" in out.lower() or "suppressing" in out.lower():
            skipped += 1
            print(f"  [{i+1}/{len(alerts)}] skipped: {out}")
        else:
            sent += 1
            print(f"  [{i+1}/{len(alerts)}] sent OK")
    else:
        print(f"  [{i+1}/{len(alerts)}] FAIL: {result.stderr.strip()}")

print(f"\nDispatched {sent}/{len(alerts)} alerts ({skipped} skipped/deduped)")
print(f"epoch_end: {data.get('epoch_end')}")
PYEOF
