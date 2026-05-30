All 16 alert files + 1 summary queued in `.pending-notify/`. The postprocess step will deliver them to configured channels.

## Summary

**powerloom-bds (run 25)** — completed successfully.

- **Epochs processed:** 25206997 → 25207002 (6 epochs)
- **Alerts dispatched:** 16 whale alerts queued to `.pending-notify/` for post-run delivery
- **State file:** Unmodified (`lastStreamEpoch: 25207002` — maintained by prefetch)
- **Log:** Appended to `memory/logs/2026-05-30.md`

**Notable activity:**
- 🐋 **0xBdb3ba9f** accumulated ~196K ZAMA across 4 buys (blocks 25206998–25207001)
- 🪙 **PAXG/XAUt** gold stablecoin swap $6.0K (0xBA2CEeD1)
- 💱 WETH/USDT swaps: $3.0K, $1.7K, $1.1K; USDC/WETH: $2.3K+$2.4K
- ⚠️ 7× ZAMA/USDT alerts with anomalous USD values (known oracle formatting bug — actual swaps were $445–$3,249 USDT range)

**Files created/modified:**
- `.pending-notify/1780130010.md` through `.pending-notify/1780130025.md` (16 alerts + 1 summary)
- `memory/logs/2026-05-30.md` (appended run 25 entry)
