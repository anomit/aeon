## Summary

**Powerloom BDS — Run 46** completed successfully.

| Metric | Value |
|--------|-------|
| Epoch range | 25216250–25216253 |
| Epochs processed | 4 |
| Alerts dispatched | 6 |
| Status | OK |

**Alerts queued in `.pending-notify/`** for post-run delivery (sandbox blocks direct `./notify` due to dollar-sign content in alert text):

1. **USDC/WETH** — 4.5K (0xBdb3ba9f)
2. **LDO/WETH** — 1.1K, 3,373 LDO (0x51C72848)
3. **WETH/LYX** — 4.1K, 10,708 LYX (anon)
4. **USDC/WETH** — 2.1K (0x51C72848)
5. **WETH/USDT** — 3.0K (0x4C82D1fB)
6. **WETH/USDT** — 4.6K (0x51C72848)

**Files modified:**
- `memory/logs/2026-05-31.md` — appended run 46 log entry
- `.pending-notify/bds-run46-alert{1-6}.md` — 6 alert files queued for postprocess delivery

**State not modified** — `memory/powerloom-bds-state.json` is maintained by the prefetch processor (lastStreamEpoch: 25216253).
