#!/usr/bin/env python3
"""Write cached BDS alerts to .pending-notify/ for post-run delivery."""
import json, hashlib, os, time

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
epoch_end = data.get('epoch_end', 'unknown')
epoch_begin = data.get('epoch_begin', 'unknown')

# Track already-sent hashes
sent_hashes = set()
hash_file = '.notify-sent-hashes'
if os.path.exists(hash_file):
    with open(hash_file) as f:
        for line in f:
            sent_hashes.add(line.strip())

os.makedirs('.pending-notify', exist_ok=True)

ts_base = int(time.time())
written = 0
skipped = 0

for i, alert in enumerate(alerts):
    h = hashlib.sha256(alert.encode()).hexdigest()
    if h in sent_hashes:
        skipped += 1
        continue

    # Record hash
    with open(hash_file, 'a') as f:
        f.write(h + '\n')
    sent_hashes.add(h)

    # Write to pending-notify
    fname = f'.pending-notify/{ts_base + i}.md'
    with open(fname, 'w') as f:
        f.write(alert)
    written += 1

print(f'Epochs {epoch_begin}-{epoch_end}')
print(f'Written: {written}, Skipped (dup): {skipped}, Total: {len(alerts)}')
