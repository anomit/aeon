## Summary

**powerloom-bds (run 26)** — completed successfully.

- **Epochs processed:** 3 (25207097–25207099)
- **Alerts dispatched:** 6
- **Status:** OK

**Alerts queued in `.pending-notify/`:**
| # | Trade | Amount | Block | Wallet |
|---|-------|--------|-------|--------|
| 1 | ID/USDC BUY | $3.0K | 25207097 | 0xBdb3ba9f |
| 2 | ZAMA/USDT BUY | 22,329 ZAMA | 25207097 | 0x278d858f |
| 3 | SKY/UNKNOWN BUY | $1.9K | 25207097 | 0x4c3ccC98 |
| 4 | PAXG/XAUt BUY | $5.9K | 25207097 | 0x4C82D1fB |
| 5 | ZAMA/USDT BUY | 44,756 ZAMA | 25207098 | 0x278d858f |
| 6 | ZAMA/USDT BUY | 519,274 ZAMA | 25207099 | 0xBdb3ba9f |

**Notes:**
- 3 ZAMA/USDT alerts had anomalous USD values (oracle formatting bug) — sanitized to show actual token/USDT amounts instead of the broken $XX-quadrillion figures
- Sandbox blocked inline `./notify` calls — all alerts written directly to `.pending-notify/` (alert-1.md through alert-6.md) for postprocess delivery
- Log entry appended to `memory/logs/2026-05-30.md`
- State file (`memory/powerloom-bds-state.json`) untouched as instructed
