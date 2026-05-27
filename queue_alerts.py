import json
import os
import hashlib
import time

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
os.makedirs('.pending-notify', exist_ok=True)

sent = 0
for alert in alerts:
    h = hashlib.sha256(alert.encode()).hexdigest()
    hash_file = '.notify-sent-hashes'
    if os.path.isfile(hash_file):
        with open(hash_file) as hf:
            if h in [line.strip() for line in hf]:
                print(f'  skip (dup): {alert[:50]}...')
                continue
    ts = int(time.time() * 1000) + sent
    with open(f'.pending-notify/{ts}.md', 'w') as pf:
        pf.write(alert)
    with open(hash_file, 'a') as hf:
        hf.write(h + '\n')
    sent += 1
    print(f'  queued [{sent}/{len(alerts)}]: {alert[:60]}...')

print(f'\nQueued {sent} alerts for delivery')
print(f'Epoch end: {data["epoch_end"]}')
