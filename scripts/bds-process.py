import json
import sys
from datetime import datetime, timezone

# Load cache
with open('.bds-cache/latest.json') as f:
    data = json.load(f)

epoch_begin = data['epoch']['begin']
epoch_end = data['epoch']['end']
trade_data = data.get('tradeData', {})
verification = data.get('verification', {})
project_id = data.get('projectId', data.get('project_id', 'unknown'))

print("Epoch range: %s - %s" % (epoch_begin, epoch_end))
print("Pools: %d" % len(trade_data))
if verification:
    print("Verification: %s" % json.dumps(verification))
print("Project ID: %s" % project_id)
print()

# Load state
with open('memory/powerloom-bds-state.json') as f:
    state = json.load(f)

last_epoch = state.get('last_epoch', 0)
emitted_fps = set(state.get('emittedFingerprints', []))
print("State last_epoch: %s" % last_epoch)
print("Already emitted fingerprints: %d" % len(emitted_fps))

# Check for stale data
if epoch_end <= last_epoch:
    print("STALE: epoch_end (%s) <= last_epoch (%s)" % (epoch_end, last_epoch))
    print("POWERLOOM_BDS_STALE")
    sys.exit(0)

# Flatten trades
all_trades = []
for pool_addr, pool_data in trade_data.items():
    trades = pool_data.get('trades', [])
    for trade in trades:
        log = trade.get('log', {})
        tx_hash = log.get('transactionHash', '')
        block_num = log.get('blockNumber', 0)
        d = trade.get('data', {})
        usd = d.get('calculated_trade_amount_usd', 0)
        amount0 = d.get('calculated_token0_amount', 0)
        amount1 = d.get('calculated_token1_amount', 0)

        all_trades.append({
            'pool': pool_addr,
            'tx': tx_hash,
            'block': block_num,
            'usd': usd,
            'amount0': amount0,
            'amount1': amount1,
            'trade_type': trade.get('tradeType', ''),
            'sender': d.get('sender', ''),
            'recipient': d.get('recipient', ''),
            'eth_price': d.get('calculated_eth_price', 0),
        })

print("Total trades: %d" % len(all_trades))

# Filter whale trades >= $1000
whale_trades = []
for t in all_trades:
    if t['usd'] >= 1000:
        fp = "%s:%s" % (t['tx'], t['block'])
        t['fingerprint'] = fp
        t['already_emitted'] = fp in emitted_fps
        whale_trades.append(t)

print("Whale trades (>=1000 USD): %d" % len(whale_trades))
already = sum(1 for t in whale_trades if t['already_emitted'])
print("Already emitted: %d" % already)

# New whales to alert
new_whales = [t for t in whale_trades if not t['already_emitted']]
print("New whale alerts to send: %d" % len(new_whales))
print()

# Build alert messages
cid = verification.get('cid', 'N/A') if verification else 'N/A'
alerts = []
for t in new_whales:
    direction = "token0 out"
    if t['amount0'] < 0:
        direction = "token0 in"
    msg_lines = [
        "Whale alert: %s | $%.2f" % (t['trade_type'], t['usd']),
        "",
        "Pool: %s" % t['pool'],
        "Amount0: %.6f | Amount1: %.8f" % (abs(t['amount0']), abs(t['amount1'])),
        "ETH price: $%.2f" % t['eth_price'],
        "Epoch: %s" % epoch_end,
        "Tx: %s" % t['tx'],
        "Verified on-chain",
        "  cid: %s" % cid,
        "  project: %s" % project_id,
    ]
    alert = "\n".join(msg_lines)
    alerts.append(alert)
    print("ALERT: Pool %s | $%.2f | Tx %s" % (t['pool'][:10], t['usd'], t['tx'][:16]))

# Update fingerprints
fps_list = list(emitted_fps)
for t in new_whales:
    fps_list.append(t['fingerprint'])
# Keep max 500 (LRU)
while len(fps_list) > 500:
    fps_list.pop(0)

# Find max block
max_block = state.get('lastEmittedBlock', 0)
for t in new_whales:
    if t['block'] > max_block:
        max_block = t['block']

# Update state
new_state = {
    "last_epoch": epoch_end,
    "lastEmittedBlock": max_block,
    "emittedFingerprints": fps_list,
    "last_run": datetime.now(timezone.utc).isoformat(),
    "alerts_sent": state.get('alerts_sent', 0) + len(new_whales),
    "mode": "whale-radar",
    "last_status": "POWERLOOM_BDS_OK"
}

with open('memory/powerloom-bds-state.json', 'w') as f:
    json.dump(new_state, f, indent=2)

print()
print("State updated. Alerts sent this run: %d" % len(new_whales))
print("Total alerts sent (all time): %d" % new_state['alerts_sent'])

# Write alerts to a temp file for notify
if alerts:
    with open('.bds-cache/alerts.txt', 'w') as f:
        for i, alert in enumerate(alerts):
            if i > 0:
                f.write("\n---\n")
            f.write(alert)
    print("Alerts written to .bds-cache/alerts.txt")
else:
    print("POWERLOOM_BDS_OK - No new whale trades above threshold")
