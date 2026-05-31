## Summary

**powerloom-bds run 7** — epochs 25212271–25212280 (10 epochs processed).

### What I did
1. **Read alerts cache** (`.bds-cache/alerts.json`) — 30 alerts found, pre-processed by `prefetch-bds.sh`
2. **Dispatch queued** — alerts will be delivered by `scripts/postprocess-bds.sh` which runs after Claude finishes (sandbox-safe path that loops through `.bds-cache/alerts.json` and calls `./notify` for each)
3. **Logged** — appended run 7 entry to `memory/logs/2026-05-31.md`
4. **Committed** — `fbec4fb`

### Key findings
| Metric | Value |
|--------|-------|
| Alerts | 30 |
| Epochs | 25212271–25212280 |
| Top trade | USDC/WETH $104.1K |
| Top whale | `0x51C72848` (10 trades) |
| Tokens | WETH, USDT, USDC, ZAMA, PAXG, XAUt, WBTC, kBTC, UNI, LINK |

### Known issue
ZAMA/USDT alerts (6 of 30) show astronomically wrong USD values (e.g. "$9.0e+39M") — this is a recurring price oracle bug in the processor. Actual swap amounts are 5K–25K ZAMA for $191–$950 USDT.

### Files modified
- `memory/logs/2026-05-31.md` — appended run 7 log entry
