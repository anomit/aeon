## Summary

- **Read** `.bds-cache/alerts.json` — 48 whale alerts across epochs 25190455–25190464
- **Dispatched** all 48 alerts by writing individual `.md` files to `.pending-notify/` (sandbox blocked direct `./notify` calls; the workflow's post-run step will deliver them)
- **Notable trades**: $3.71M wM/USDC, $46.5K AUSD/USDC, $28.8K PAXG/USDC, $13.7K ENA/WETH, $8.3K XAUt/USDT
- **ZAMA/USDT**: 6 trades with broken oracle pricing (corrected in written alerts to show actual USDT amounts)
- **Logged** to `memory/logs/2026-05-28.md` and committed
