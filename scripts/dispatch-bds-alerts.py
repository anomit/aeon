#!/usr/bin/env python3
"""Dispatch BDS alerts from .bds-cache/alerts.json via ./notify or .pending-notify/."""
import json, os, hashlib, time, subprocess, sys

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
epoch_end = data.get('epoch_end', 'unknown')
epoch_begin = data.get('epoch_begin', 'unknown')
epochs_processed = data.get('epochs_processed', 0)

if not alerts:
    print(f'No alerts to dispatch (epoch_end={epoch_end})')
    sys.exit(0)

os.makedirs('.pending-notify', exist_ok=True)

sent_hashes = set()
hash_file = '.notify-sent-hashes'
if os.path.exists(hash_file):
    with open(hash_file) as f:
        for line in f:
            sent_hashes.add(line.strip())

count = 0
skipped = 0
failed = 0
ts_base = int(time.time())

for i, alert in enumerate(alerts):
    h = hashlib.sha256(alert.encode()).hexdigest()
    if h in sent_hashes:
        skipped += 1
        continue

    # Record hash
    with open(hash_file, 'a') as f:
        f.write(h + '\n')

    # Save to .pending-notify/ as fallback
    fname = '.pending-notify/' + str(ts_base + i) + '.md'
    with open(fname, 'w') as f:
        f.write(alert)

    # Try immediate delivery
    try:
        result = subprocess.run(
            ['./notify', alert],
            capture_output=True, text=True, timeout=30
        )
        if result.returncode == 0:
            count += 1
        else:
            failed += 1
            print(f'notify error: {result.stderr[:120]}', file=sys.stderr)
    except Exception as e:
        failed += 1
        print(f'notify exception: {e}', file=sys.stderr)

print(f'Epochs {epoch_begin}-{epoch_end} ({epochs_processed} processed)')
print(f'Dispatched: {count} OK, {failed} failed, {skipped} duplicates skipped, {len(alerts)} total')
