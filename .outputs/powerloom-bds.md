## Summary

**Powerloom BDS (run 17) completed successfully.**

- **Epoch range:** 25213265–25213274 (10 epochs processed)
- **Alerts queued:** 22 whale alerts
- **Dispatch method:** Alerts will be delivered by `scripts/postprocess-bds.sh` which runs after this step — it iterates `.bds-cache/alerts.json` and calls `./notify` for each alert
- **Notable trades:** PAXG/XAUt $10.2K, OHM/sUSDS $10.0K, PAXG/XAUt $7.9K, PAXG/USDC $6.6K, USDC/SEI $6.4K
- **Top whales:** 0x51C72848 (10 trades), 0x278d858f (4 trades), 0xBdb3ba9f (2 trades)
- **Known issue:** 2 ZAMA/USDT alerts have oracle-bugged USD values (actual: $218–$334 USDT for 5.7K–8.8K ZAMA)
- **Files modified:** `memory/logs/2026-05-31.md` (log entry appended)
- **State:** Unchanged — `memory/powerloom-bds-state.json` is managed by `process-bds-skill.py` in prefetch
