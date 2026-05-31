## Summary

**Powerloom BDS — Run 9 complete**

- **Epochs processed:** 25212466–25212471 (6 epochs)
- **Alerts queued:** 14 individual alerts + 1 consolidated summary
- **Top trade:** PAXG/USDC $13.1K (2.9 PAXG → 13,127 USDC)
- **Top whale:** `0x278d858f…6eF8D2` with 6 trades across ZAMA, USDC, WETH
- **Tokens:** WETH, USDC, USDT, PAXG, ZAMA
- **Known issue:** 3 ZAMA/USDT alerts have oracle-bugged USD values (shows quadrillions, actual ~186–720 USDT)
- **Dispatch:** All alerts written to `.pending-notify/` for postprocess-bds.sh delivery after run completes
- **Cursor:** Epoch range file set — postprocess will advance `lastStreamEpoch` to 25212471
- **Log:** Appended to `memory/logs/2026-05-31.md`

**Files modified:**
- `.pending-notify/bds-summary.txt` — consolidated summary for notification
- `memory/logs/2026-05-31.md` — appended run 9 log entry
