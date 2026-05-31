#!/usr/bin/env python3
import json, subprocess, sys

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
if not alerts:
    print("No alerts to dispatch")
    sys.exit(0)

count = 0
for i, alert in enumerate(alerts):
    r = subprocess.run(['./notify', alert], capture_output=True, text=True)
    if r.returncode == 0:
        count += 1
        print(f'[{i+1}/{len(alerts)}] OK')
    else:
        print(f'[{i+1}/{len(alerts)}] FAIL: {r.stderr.strip()}')

print(f'Sent {count}/{len(alerts)} | epoch_end={data["epoch_end"]}')
