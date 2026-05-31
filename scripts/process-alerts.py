#!/usr/bin/env python3
import json, hashlib, os, time

base = "/home/runner/work/aeon/aeon"

with open(base + "/.bds-cache/alerts.json", "r") as f:
    data = json.load(f)

alerts = data["alerts"]
epoch_end = data["epoch_end"]

hash_file = base + "/.notify-sent-hashes"
existing_hashes = set()
if os.path.exists(hash_file):
    with open(hash_file, "r") as f:
        for line in f:
            stripped = line.strip()
            if stripped:
                existing_hashes.add(stripped)

dispatched = 0
skipped = 0
new_hashes = []

for i, alert_text in enumerate(alerts):
    h = hashlib.sha256(alert_text.encode("utf-8")).hexdigest()
    if h in existing_hashes:
        skipped += 1
        print("SKIP Alert {} (duplicate)".format(i + 1))
        continue

    ts = int(time.time() * 1000) + i
    pending_file = base + "/.pending-notify/{}.md".format(ts)
    with open(pending_file, "w") as f:
        f.write(alert_text)
    print("DISPATCH Alert {} -> {}.md".format(i + 1, ts))

    new_hashes.append(h)
    dispatched += 1

with open(hash_file, "a") as f:
    for h in new_hashes:
        f.write(h + "\n")

print("---")
print("Total alerts in cache: {}".format(len(alerts)))
print("Dispatched: {}".format(dispatched))
print("Skipped (duplicates): {}".format(skipped))
print("epoch_end: {}".format(epoch_end))
