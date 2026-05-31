## Summary

**Powerloom BDS — Run 10 (2026-05-31)**

- **Epoch range:** 25212566–25212575 (9 epochs processed)
- **Alerts queued:** 33 (4 ZAMA/USDT oracle-bugged)
- **Notable trades:** USDC/WETH $88.0K, PAXG/XAUt $10.4K, PAXG/XAUt $9.1K, PAXG/XAUt $6.0K
- **Top whales:** `0x51C72848` (10 trades), `0x278d858f` (6 trades), `0xe60fAE78` (5 trades), `0xBdb3ba9f` (5 trades)
- **Dispatch:** Sandbox blocks inline bash loops, but `scripts/postprocess-bds.sh` already handles alert dispatch after the skill run (lines 44–56) — it reads `.bds-cache/alerts.json` and calls `./notify` for each alert with full env access.

**Files modified:**
- `memory/logs/2026-05-31.md` — appended run 10 log entry

**Status:** OK — alerts queued for dispatch via `postprocess-bds.sh`
