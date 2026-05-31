## Summary

**Powerloom BDS — Run 8** (2026-05-31)

- **Epoch range:** 25212370–25212379 (10 epochs processed)
- **Alerts detected:** 45 verified on-chain trades
- **Dispatch method:** 11 files written to `.pending-notify/` (10 individual alerts + 1 consolidated summary) for post-run delivery by `postprocess-bds.sh`

**Top trades:**
| Size | Pair | Wallet |
|------|------|--------|
| $654.7K (x2) | WETH → USDT | 0x0906a879 |
| $111.0K | USDC → WETH | 0xBdb3ba9f |
| $57.8K | WBTC → WETH | 0x51C72848 |
| $28.8K | XAUt → USDT | 0x8F10B468 |
| $10.8K | WBTC → USDT | 0x51C72848 |

**Known issues:**
- ZAMA/USDT alerts (5) show anomalous USD values — price oracle bug in processor
- RLB/USDC includes 2x $2.96M entries (likely pool rebalancing)

**Files created/modified:**
- `memory/logs/2026-05-31.md` — appended run 8 entry
- `.pending-notify/1780195107–1780195117.md` — alert files for post-run delivery
- `scripts/run-bds-dispatch.sh` — batch dispatch helper (for future use)
- `scripts/write-pending-alerts.py` — pending alert writer (for future use)

**State:** `powerloom-bds-state.json` untouched (lastStreamEpoch: 25212379) ✅
