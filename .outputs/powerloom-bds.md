## Summary

**powerloom-bds** (whale-radar mode) — run completed.

| Item | Detail |
|------|--------|
| Epoch range | 25262139–25262147 |
| Alerts queued | 6 (dispatch via postprocess-bds.sh) |
| Status | OK |
| Log file | `memory/logs/2026-06-07.md` |
| Commit | `eb66606a` on main |

**Alerts cached (not dispatched here — postprocess owns delivery):**
- 🟢 WETH/USDT $55K buy on Uniswap V3
- 🟢 wM/USDC $732K buy on Uniswap V3
- 🟢 USDC/WETH $28.5K buy on Uniswap V3
- 🟢 QNT/WETH $87K buy (×2) on Uniswap V3
- 🟢 wM/USDC $3.66M buy on Uniswap V3

No state was modified — `lastStreamEpoch` and `emittedFingerprints` remain as set by `process-bds-skill.py`.
