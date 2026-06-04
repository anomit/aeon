## Summary

**Skill: Powerloom BDS — whale-radar mode**

- **Read alerts cache** (`.bds-cache/alerts.json`): 9 whale alerts queued across epoch range 25247057–25247066 (10 epochs processed)
- **Did not dispatch** — postprocess-bds.sh handles Telegram/Discord/Slack delivery
- **Logged** run to `memory/logs/2026-06-04.md` and committed

**Notable alerts in this batch:**
- Two large $3.33M USDC→WETH swaps on Uniswap V3 1% pool (blocks 25247066)
- Multiple mid-size buys ($25.7K–$165.1K) across USDC/WETH and WETH/USDT pools
- BUY-side dominant; all verified on-chain via Powerloom BDS snapshots
