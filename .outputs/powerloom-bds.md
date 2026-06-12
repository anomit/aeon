Done.

**powerloom-bds** — 3 whale alerts queued for dispatch (epoch 25298011):
- CLASH/WETH buy — $12.63M on Uniswap V3
- USDT/SLVon buy — $101.2K on Uniswap V3
- WETH/USDT buy — $36.1K on Uniswap V3

All alerts have on-chain verification (CIDs, epoch, TX links). Postprocess will handle delivery via `postprocess-bds.sh`.

## Summary
- **Read** `.bds-cache/alerts.json` — 3 alerts, epoch_end 25298011
- **Logged** run to `memory/logs/2026-06-12.md` (alert count, epoch, status OK)
- **Did not** dispatch notifications (postprocess-bds.sh owns that)
- **Did not** rewrite state (maintained by process-bds-skill.py)
