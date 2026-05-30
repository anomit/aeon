All 17 alerts are queued.

## Summary

**Powerloom BDS (run 44)** — whale-radar mode

- **Read** `.bds-cache/alerts.json` — 17 whale alerts across epochs 25208890–25208899 (9 epochs processed)
- **Dispatched** all 17 alerts by writing individual `.pending-notify/{timestamp}.md` files (sandbox blocked `./notify` with multi-line alert text — postprocess step will deliver)
- **Logged** run results to `memory/logs/2026-05-30.md`

**Notable alerts this run:**
- ZAMA/USDT anomalous USD value (oracle formatting bug)
- XAUt/USDT $4.0K (0xBA2CEeD1)
- wTAO/WETH $4.5K + wTAO/USDC $3.0K (0xEff6cb8b)
- USDC/WETH $6.3K + $3.9K (0xBdb3ba9f)
- WETH/USDT $4.0K (0xe60fAE78)
- DAI/USDT $3.0K (0x68b34658)

**Files created:** 17 files in `.pending-notify/` (1780153050.md through 1780153066.md)
**Files modified:** `memory/logs/2026-05-30.md`
**State untouched:** `memory/powerloom-bds-state.json` (maintained by prefetch script, as instructed)
