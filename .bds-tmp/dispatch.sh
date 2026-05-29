#!/usr/bin/env bash
set -euo pipefail
FILE="$1"
MSG=$(<"$FILE")
./notify "$MSG"
