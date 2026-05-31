## Summary

**Powerloom BDS — run 2 for 2026-05-31**

- **Epochs processed:** 25211773–25211782 (9 epochs)
- **Alerts queued:** 19 whale alerts
- **Notable trades:** RLB/USDC $113.8K (×2), USDC/WETH $36.7K, USDC/WETH $21.1K, GHO/USDC $4.8K, WBTC/USDT $4.1K
- **Tokens:** WETH, USDT, USDC, cbETH, ZAMA, GHO, RLB, WBTC
- **Data quality note:** ZAMA/USDT alert shows an anomalous inflated USD value (~$16.2K ZAMA for only $590 USDT actual) — likely a price oracle or decimals issue in the snapshot
- **Dispatch:** `postprocess-bds.sh` will send all 19 alerts via `./notify` after this session
- **Log updated:** `memory/logs/2026-05-31.md`
- **State:** `lastStreamEpoch` already at 25211782 (maintained by processor, not rewritten)
