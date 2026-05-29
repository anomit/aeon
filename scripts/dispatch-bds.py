#!/usr/bin/env python3
"""Write BDS alerts to .pending-notify/ for post-run delivery.
Used when sandbox blocks direct ./notify dispatch."""
import json, hashlib, time

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
ts_base = int(time.time())

for i, alert in enumerate(alerts):
    # Compute hash for dedup
    h = hashlib.sha256(alert.encode()).hexdigest()
    with open('.notify-sent-hashes', 'a') as hf:
        hf.write(h + '\n')
    # Write to pending-notify with unique timestamp
    ts = ts_base + i
    with open(f'.pending-notify/{ts}.md', 'w') as pf:
        pf.write(alert)
    print(f'[{i+1}/{len(alerts)}] queued {h[:8]}')

print(f'\nQueued {len(alerts)} alerts for post-run delivery')
print(f'epoch_end={data["epoch_end"]}')
print(f'epoch_begin={data["epoch_begin"]}')
print(f'total={len(alerts)}')
