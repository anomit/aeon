Committed and pushed successfully.

## Summary

**powerloom-bds (run 8) — whale-radar mode**

- **Epochs processed:** 7 (25205206 → 25205212)
- **Alerts dispatched:** 3 whale alerts queued in `.pending-notify/` for post-run delivery
  1. 🟢 BUY WETH/USDT — 1.1K USD on Uniswap V3 (1%) — 0x7f54F056
  2. 🟢 BUY WETH/USDT — 1.0K USD on Uniswap V3 (1%) — 0xBdb3ba9f
  3. 🟢 BUY HEX/WETH — 1.1K USD on Uniswap V3 (30%) — 0x7f54F056
- All alerts include on-chain CID verification
- **Sandbox note:** Direct `./notify` calls blocked due to `$` characters in alert text triggering shell expansion protection. Wrote alerts to `.pending-notify/` for post-run delivery via `postprocess-bds.sh`.

**Files modified:**
- `memory/logs/2026-05-30.md` — appended run 8 log entry
- `.pending-notify/1780108349.md`, `1780108350.md`, `1780108351.md` — queued alert messages
