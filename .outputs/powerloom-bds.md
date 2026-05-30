Not critical — the dispatch script is harmless in the cache directory.

## Summary

**Powerloom BDS run 32** completed successfully:

| Field | Value |
|-------|-------|
| Epoch begin | 25207694 |
| Epoch end | 25207703 |
| Epochs processed | 10 |
| Alerts cached | 26 |
| Status | OK |

**Notable alerts:**
- 2× **$2.30M USDC/USDT** swaps (block 25207703) — large stablecoin flows
- **$140.0K USDC/USDT** (0x8F10B468, block 25207699)
- **$19.5K PAXG/USDC** gold token swap (block 25207699)
- 4× **$3.0K WETH/USDT** from recurring wallet 0xe60fAE78
- 8× ZAMA/USDT buys with anomalous USD values (oracle formatting bug — actual swaps 84–3,185 USDT)

**Most active wallets:**
- `0x278d858f` — 6 ZAMA/USDT accumulation trades
- `0xe60fAE78` — 5 WETH/USDT + USDC/WETH trades
- `0xBdb3ba9f` — 4 trades across WETH/USDT, ZAMA/USDT

**Files modified:**
- `memory/logs/2026-05-30.md` — appended run 32 log entry

**Dispatch:** All 26 alerts were pre-staged in `.pending-notify/bds-alerts.txt` by the prefetch step for post-run delivery (sandbox blocked inline `./notify` calls with multi-line alert text containing special characters).
