Run complete. Two whale alerts were cached for dispatch:

1. **LINK/WETH** — $35.0K BUY on Uniswap V3 (block 25256054)
2. **WETH/USDT** — $433.3K BUY on Uniswap V3 (block 25256060)

Both carry on-chain verification CIDs from `allTradesSnapshot`. Notifications will be dispatched by `postprocess-bds.sh`.

## Summary

- **Read** `.bds-cache/alerts.json` — 2 alerts, epoch range 25256054–25256063
- **Did not dispatch** (postprocess-bds.sh owns that)
- **Logged** run to `memory/logs/2026-06-06.md` with epoch end 25256063, 2 alerts queued
- **Status**: `POWERLOOM_BDS_OK`
