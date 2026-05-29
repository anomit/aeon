#!/usr/bin/env python3
"""Dispatch all alerts from .bds-cache/alerts.json via ./notify"""
import json, subprocess, sys

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
print(f"Dispatching {len(alerts)} alerts...")

for i, alert in enumerate(alerts):
    result = subprocess.run(['./notify', alert], capture_output=True, text=True)
    status = "OK" if result.returncode == 0 else f"FAIL (exit {result.returncode})"
    print(f"  Alert {i+1}/{len(alerts)}: {status}")
    if result.stderr:
        print(f"    stderr: {result.stderr.strip()}")

print(f"Done. {len(alerts)} alerts processed.")
