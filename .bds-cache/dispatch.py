#!/usr/bin/env python3
import json, subprocess, sys
with open('.bds-cache/alerts.json') as f:
    data = json.load(f)
for alert in data['alerts']:
    r = subprocess.run(['./notify', alert], capture_output=True, text=True)
    print(f'sent: {r.returncode}')
    if r.stdout: print(r.stdout)
    if r.stderr: print(r.stderr)
print(f'total: {len(data["alerts"])}')
