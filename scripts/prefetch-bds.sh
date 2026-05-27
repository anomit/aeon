#!/bin/bash
# Pre-fetch BDS data before the skill runs
# This script runs with full env access (including BDS_API_KEY from GitHub secrets)
# before the Claude sandbox starts.

set -e

echo "=== Powerloom BDS Pre-fetch ==="
echo "Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Check for API key
if [ -z "$BDS_API_KEY" ]; then
    echo "ERROR: BDS_API_KEY not set"
    echo "Add BDS_API_KEY to your GitHub repository secrets"
    exit 1
fi

# Create cache directory
mkdir -p .bds-cache memory

# Install bds-agent if not present
if ! command -v bds-agent &> /dev/null; then
    echo "Installing bds-agent from PyPI..."
    pip install bds-agent
fi

# Read config to determine what to fetch
CONFIG_FILE="memory/powerloom-bds.yml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "WARN: No config file at $CONFIG_FILE"
    echo "Creating default config..."
    cat > "$CONFIG_FILE" << 'EOF'
mode: whale-radar

thresholds:
  whale_usd: 25000

pulse:
  window_minutes: 5
  cooldown_minutes: 10

analyst:
  report_cadence: hourly
  include_verification_probe: true
EOF
    echo "Created default config at $CONFIG_FILE"
fi

# Extract mode from config
MODE=$(grep -E '^mode:' "$CONFIG_FILE" | awk '{print $2}' || echo "whale-radar")
echo "Mode: $MODE"

# Read last epoch from state file (for epoch cursor)
STATE_FILE="memory/powerloom-bds-state.json"
LAST_EPOCH=""
if [ -f "$STATE_FILE" ]; then
    LAST_EPOCH=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('lastStreamEpoch', '') or '')" 2>/dev/null || echo "")
fi

export BDS_BASE_URL="${BDS_BASE_URL:-https://bds.powerloom.io/api}"
export FROM_EPOCH=""
export BDS_MAX_STREAM_EVENTS="${BDS_MAX_STREAM_EVENTS:-100}"
export BDS_MAX_STREAM_LOOPS="${BDS_MAX_STREAM_LOOPS:-10}"

if [ -n "$LAST_EPOCH" ] && [ "$LAST_EPOCH" != "null" ] && [ "$LAST_EPOCH" != "None" ]; then
    echo "Resuming from epoch: $LAST_EPOCH"
    FROM_EPOCH=$((LAST_EPOCH + 1))
    export FROM_EPOCH
    echo "Stream from_epoch: $FROM_EPOCH"
else
    echo "No previous epoch found, streaming from latest finalized"
fi

# Catch up via SSE — snapshot GET ignores from_epoch/max_events (see endpoints.json).
python3 << 'PYTHON'
import os
import json
import asyncio
from bds_agent.client import fetch, stream

CACHE_DIR = ".bds-cache"
MAX_EVENTS = int(os.environ.get("BDS_MAX_STREAM_EVENTS", "100"))
MAX_LOOPS = int(os.environ.get("BDS_MAX_STREAM_LOOPS", "10"))


def _epoch_end(snapshot: dict) -> int | None:
    epoch = snapshot.get("epoch")
    if not isinstance(epoch, dict):
        return None
    end = epoch.get("end")
    if end is None:
        end = epoch.get("begin")
    try:
        return int(end)
    except (TypeError, ValueError):
        return None


def _collect_pool_addresses(events: list[dict]) -> set[str]:
    pools: set[str] = set()
    for ev in events:
        trade_data = ev.get("tradeData")
        if not isinstance(trade_data, dict):
            continue
        for pool_raw in trade_data:
            pool = str(pool_raw).lower()
            if pool.startswith("0x") and len(pool) >= 42:
                pools.add(pool)
    return pools


def _pool_info_from_metadata(data: dict | None) -> dict | None:
    if not isinstance(data, dict):
        return None
    token0 = data.get("token0") if isinstance(data.get("token0"), dict) else {}
    token1 = data.get("token1") if isinstance(data.get("token1"), dict) else {}
    sym0 = token0.get("symbol")
    sym1 = token1.get("symbol")
    if not sym0 or not sym1:
        return None
    try:
        fee_bps = int(data.get("fee") or 0)
    except (TypeError, ValueError):
        fee_bps = 0
    if fee_bps >= 10000:
        fee = f"{fee_bps / 10000:g}%"
    elif fee_bps >= 100:
        fee = f"{fee_bps / 100:g}%"
    else:
        fee = f"{fee_bps:g}%"
    return {"t0": str(sym0), "t1": str(sym1), "fee": fee}


async def _resolve_pool_metadata(
    base_url: str,
    api_key: str,
    events: list[dict],
) -> dict[str, dict]:
    cache_path = f"{CACHE_DIR}/pool-metadata.json"
    cache: dict[str, dict] = {}
    if os.path.isfile(cache_path):
        try:
            with open(cache_path) as f:
                loaded = json.load(f)
            if isinstance(loaded, dict):
                cache = {
                    str(k).lower(): v
                    for k, v in loaded.items()
                    if isinstance(v, dict)
                }
        except (OSError, json.JSONDecodeError):
            cache = {}

    needed = _collect_pool_addresses(events)
    fetched = 0
    for pool in sorted(needed):
        if pool in cache:
            continue
        try:
            result = await fetch(base_url, f"/mpp/pool/{pool}/metadata", api_key)
            info = _pool_info_from_metadata(result.data)
            if info:
                cache[pool] = info
                fetched += 1
        except Exception as exc:
            print(f"WARN: pool metadata failed for {pool}: {exc}")

    with open(cache_path, "w") as f:
        json.dump(cache, f, indent=2)
    print(f"Pool metadata cache: {len(cache)} pools ({fetched} fetched this run)")
    return cache


async def _stream_batch(base_url: str, api_key: str, from_epoch: int | None) -> list[dict]:
    events: list[dict] = []
    async for chunk in stream(
        base_url,
        "/mpp/stream/allTrades",
        api_key,
        from_epoch=from_epoch,
        max_events=MAX_EVENTS,
        reconnect=False,
    ):
        if isinstance(chunk.data, dict):
            events.append(chunk.data)
    return events


async def main() -> None:
    base_url = os.environ.get("BDS_BASE_URL", "https://bds.powerloom.io/api")
    api_key = os.environ["BDS_API_KEY"]
    from_epoch_raw = os.environ.get("FROM_EPOCH", "").strip()
    cursor = int(from_epoch_raw) if from_epoch_raw else None

    all_events: list[dict] = []
    for loop in range(MAX_LOOPS):
        batch = await _stream_batch(base_url, api_key, cursor)
        if not batch:
            if loop == 0 and cursor is None:
                result = await fetch(base_url, "/mpp/snapshot/allTrades", api_key)
                if isinstance(result.data, dict):
                    batch = [result.data]
            if not batch:
                break

        all_events.extend(batch)
        ends = [_epoch_end(ev) for ev in batch]
        ends = [e for e in ends if e is not None]
        if not ends:
            break

        print(
            f"Stream loop {loop + 1}: events={len(batch)} "
            f"epoch_range={min(ends)}-{max(ends)} total={len(all_events)}",
        )

        if len(batch) < MAX_EVENTS:
            break

        cursor = max(ends)

    os.makedirs(CACHE_DIR, exist_ok=True)
    with open(f"{CACHE_DIR}/stream-events.json", "w") as f:
        json.dump(all_events, f, indent=2)

    if all_events:
        with open(f"{CACHE_DIR}/latest.json", "w") as f:
            json.dump(all_events[-1], f, indent=2)

        ends = [_epoch_end(ev) for ev in all_events]
        ends = [e for e in ends if e is not None]
        begins = []
        for ev in all_events:
            epoch = ev.get("epoch") if isinstance(ev.get("epoch"), dict) else {}
            begin = epoch.get("begin")
            if begin is not None:
                try:
                    begins.append(int(begin))
                except (TypeError, ValueError):
                    pass
        if ends:
            with open(f"{CACHE_DIR}/epoch_range.txt", "w") as f:
                f.write(f"{min(begins) if begins else min(ends)}\n{max(ends)}\n")
            print(f"Cached {len(all_events)} epoch(s): {min(begins) if begins else min(ends)} - {max(ends)}")
        await _resolve_pool_metadata(base_url, api_key, all_events)
    else:
        print("WARN: no BDS events fetched")

    print("Successfully cached BDS stream data")


asyncio.run(main())
PYTHON

# Deterministic alert processing + epoch cursor (OpenClaw parity)
python3 scripts/process-bds-skill.py

echo "=== Pre-fetch complete ==="
echo "Cached data in .bds-cache/"
ls -la .bds-cache/

exit 0
