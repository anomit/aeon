import json
import subprocess
import sys

with open('.bds-cache/alerts.json') as f:
    data = json.load(f)

alerts = data['alerts']
print(f'Dispatching {len(alerts)} alerts...')

for i, alert in enumerate(alerts):
    result = subprocess.run(
        ['./notify', alert],
        capture_output=True, text=True, timeout=30
    )
    status = 'ok' if result.returncode == 0 else f'fail({result.returncode})'
    stderr = result.stderr.strip()
    if stderr:
        print(f'  [{i+1}/{len(alerts)}] {status}: {stderr[:80]}')
    else:
        print(f'  [{i+1}/{len(alerts)}] {status}')

print(f'Epoch end: {data["epoch_end"]}')
print(f'Done: {len(alerts)} alerts processed')
