#!/usr/bin/env python3
"""Write alerts to .pending-notify/ for postprocess delivery."""
import json, os, time

os.chdir("/home/runner/work/aeon/aeon")
with open(".bds-cache/alerts.json") as f:
    data = json.load(f)

alerts = data["alerts"]
t = int(time.time())
os.makedirs(".pending-notify", exist_ok=True)

for i, alert in enumerate(alerts):
    path = f".pending-notify/{t + i}_{i}.md"
    with open(path, "w") as out:
        out.write(alert)

print(f"Wrote {len(alerts)} alerts to .pending-notify/")
print(f"epoch_end: {data.get('epoch_end')}")
