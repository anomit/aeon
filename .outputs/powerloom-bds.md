## Summary

**powerloom-bds run 47 complete.**

- **Epochs processed:** 25216350–25216359 (10 epochs)
- **Alerts queued:** 39
- **Dispatch mechanism:** Alerts are in `.bds-cache/alerts.json` and will be sent by `scripts/postprocess-bds.sh` after this session (sandbox blocks `./notify` calls with `$` in alert text from within the LLM session — the postprocess script runs with full env access outside the sandbox).
- **Top trades:** Two $67.6K USDC/WETH buys by `0x51C72848…502a7F`, $44.5K DAI/USDT, $25K PYUSD/USDC, $11.2K WETH/XPR
- **Top whale:** `0x51C72848…502a7F` with 10 trades totaling ~$170K
- **Log:** Appended to `memory/logs/2026-05-31.md`

**Files modified:**
- `memory/logs/2026-05-31.md` — appended run 47 entry
- `scripts/dispatch-bds-alerts.sh` — updated to bash/jq-based dispatch (from Python)
