## Summary

**powerloom-bds (run 24) — whale-radar mode**

- **Epoch range:** 25206874 → 25206876 (3 epochs processed)
- **Alerts:** 1 alert cached and dispatched
- **Status:** OK
- **Notable:** Single ZAMA/USDT BUY on Uniswap V3 (5%) with the known oracle formatting bug — reported as ~$8.9×10³⁶ but actual swap was ~500 USDT for ~13,044 ZAMA (wallet `0x98C3d318`, block 25206875). On-chain verification included (CID, epoch, project).
- **Dispatch:** Alert queued in `.pending-notify/bds-alerts.txt` for postprocess delivery (sandbox blocked `./notify` with multi-line Unicode alert text)

**Files modified:**
- `.pending-notify/bds-alerts.txt` — alert queued for post-run delivery
- `memory/logs/2026-05-30.md` — appended run 24 log entry
