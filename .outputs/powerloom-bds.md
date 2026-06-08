## Summary

**powerloom-bds (run 27) — OK**

- Read `.bds-cache/alerts.json`: 4 whale alerts queued from epochs 25271602–25271611 (10 epochs processed)
- Did **not** dispatch — `postprocess-bds.sh` handles Telegram/Discord/Slack delivery
- Did **not** touch `memory/powerloom-bds-state.json` (maintained by prefetch script only)
- Appended log entry to `memory/logs/2026-06-08.md`

**Alerts queued for dispatch:**
1. 🐳 BUY USDC/WETH — $38.7K on Uniswap V3 (block 25271606)
2. 🐳 BUY WBTC/WETH — $36.2K on Uniswap V3 (block 25271608)
3. 🐳 BUY WETH/USDT — $39.1K on Uniswap V3 (block 25271608)
4. 🐳 BUY USDC/USDT — $200.1K on Uniswap V3 (block 25271609)

All carry on-chain CID verification. Postprocess will deliver them.
