#!/usr/bin/env bash
set -euo pipefail
cd /home/runner/work/aeon/aeon

# Dispatch BDS alerts from cached JSON
# Uses jq to extract each alert string and sends via ./notify
TOTAL=$(jq '.alerts | length' .bds-cache/alerts.json)
SENT=0
SKIP=0

for i in $(seq 0 $((TOTAL - 1))); do
    ALERT=$(jq -r ".alerts[$i]" .bds-cache/alerts.json)
    OUT=$(./notify "$ALERT" 2>&1) && RC=$? || RC=$?
    if [ $RC -eq 0 ]; then
        case "$OUT" in
            *uppressing*|*uplicate*) SKIP=$((SKIP + 1)); echo "  [$((i+1))/$TOTAL] skipped" ;;
            *) SENT=$((SENT + 1)); echo "  [$((i+1))/$TOTAL] sent" ;;
        esac
    else
        echo "  [$((i+1))/$TOTAL] FAIL: $OUT"
    fi
done

echo ""
echo "Dispatched $SENT/$TOTAL alerts ($SKIP skipped/deduped)"
echo "epoch_end: $(jq -r '.epoch_end' .bds-cache/alerts.json)"
