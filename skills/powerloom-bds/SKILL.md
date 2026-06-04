---
name: Powerloom BDS
description: Verified on-chain data from Powerloom BDS — whale alerts, token flow, pulse signals, DeFi analysis
schedule: "*/5 * * * *"
tags: [crypto, defi, data]
permissions:
  - contents:write
---

> **${var}** — Mode to run: `whale-radar` (default) | `token-flow` | `pulse` | `defi-analyst`. If empty, defaults to `whale-radar`.

## Goal

Confirm pre-processed BDS whale alerts and log the run. Prefetch + `scripts/process-bds-skill.py` already advanced the epoch cursor, deduplicated trades, and wrote `.bds-cache/alerts.json`. **`scripts/postprocess-bds.sh`** (after this step) calls `./notify` for each alert — do not rely on the LLM to dispatch.

This skill **must not** re-fetch, summarize alerts into tables for delivery, or rewrite cursor state.

Every alert carries on-chain verification when present in the cached snapshot.

## Pre-conditions

`scripts/prefetch-bds.sh` has already:

1. Read `lastStreamEpoch` from `memory/powerloom-bds-state.json`
2. Fetched `/mpp/snapshot/allTrades` from `lastStreamEpoch + 1` (or latest)
3. Run `scripts/process-bds-skill.py` → updated state + `.bds-cache/alerts.json`

## Steps

### 1. Read alerts cache

Read `.bds-cache/alerts.json`. Structure:

```json
{
  "alerts": ["🐳 Whale alert: ...", "..."],
  "epoch_end": 25149997
}
```

If missing or `alerts` is empty:

- Append to `memory/logs/${today}.md`: `powerloom-bds — no alerts`
- End silently with log code `POWERLOOM_BDS_OK`

### 2. Do not dispatch here

**Do not** call `./notify` and **do not** write markdown tables or “alert summary” posts — postprocess owns Telegram/Discord/Slack delivery.

Only note `alert_count` from `alerts.length` for logging.

### 3. Log

Append to `memory/logs/${today}.md`:

```markdown
### powerloom-bds
- Epoch end: {epoch_end}
- Alerts queued: {count} (dispatch via postprocess-bds.sh)
- Status: OK
```

## State (do not rewrite)

`memory/powerloom-bds-state.json` is maintained by **`scripts/process-bds-skill.py`** in prefetch. Do not decrement `lastStreamEpoch` or clear `emittedFingerprints`.

## Error handling

| Condition | Action |
|-----------|--------|
| No config | Log `POWERLOOM_BDS_NO_CONFIG`, end silently |
| Cache/alerts missing | Log `POWERLOOM_BDS_CACHE_MISS`, end silently |
| Empty alerts | Log `POWERLOOM_BDS_OK`, end silently |

## Non-whale modes

`token-flow`, `pulse`, and `defi-analyst` are **not** deterministic in prefetch yet. For those modes, log `POWERLOOM_BDS_MODE_SKIP` and end — use OpenClaw scripts locally until ported.

## Resources

- `references/bds-api.md` — BDS endpoint catalog
- `references/verification.md` — How to verify CIDs on-chain
- `references/architecture.md` — Prefetch / skill / postprocess split
- https://docs.powerloom.io/agents-and-bds/quickstart
