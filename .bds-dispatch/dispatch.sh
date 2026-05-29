#!/usr/bin/env bash
set -euo pipefail

# Extract each alert from alerts.json and dispatch via ./notify
# Using python to parse JSON, then xargs to call notify

python3 -c "
import json, subprocess
with open('.bds-cache/alerts.json') as f:
    data = json.load(f)
alerts = data['alerts']
print(f'Dispatching {len(alerts)} alerts...')
ok=0; dup=0; fail=0
for i, alert in enumerate(alerts):
    r = subprocess.run(['./notify', alert], capture_output=True, text=True, timeout=30)
    stderr = r.stderr.strip()
    if r.returncode == 0:
        if 'duplicate' in stderr.lower() or 'skipping' in stderr.lower():
            dup += 1
            print(f'  [{i+1}/{len(alerts)}] DUP - {stderr}')
        else:
            ok += 1
            print(f'  [{i+1}/{len(alerts)}] OK')
    else:
        fail += 1
        print(f'  [{i+1}/{len(alerts)}] FAIL - {stderr}')
print(f'Results: {ok} sent, {dup} duplicates, {fail} failed')
"
