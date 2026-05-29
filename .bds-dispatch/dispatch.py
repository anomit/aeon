#!/usr/bin/env python3
"""Dispatch all alerts from .bds-cache/alerts.json via ./notify"""
import json, subprocess, sys

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
print(f'Dispatching {len(alerts)} alerts...')

ok = 0
fail = 0
dup = 0
for i, alert in enumerate(alerts):
    result = subprocess.run(
        ['./notify', alert],
        capture_output=True, text=True, timeout=30
    )
    stderr = result.stderr.strip()
    if result.returncode == 0:
        if 'duplicate' in stderr.lower() or 'skipping' in stderr.lower():
            dup += 1
            print(f'  [{i+1}/{len(alerts)}] DUP - {stderr}')
        else:
            ok += 1
            print(f'  [{i+1}/{len(alerts)}] OK')
    else:
        fail += 1
        print(f'  [{i+1}/{len(alerts)}] FAIL - {stderr}')

print(f'\nResults: {ok} sent, {dup} duplicates, {fail} failed')
