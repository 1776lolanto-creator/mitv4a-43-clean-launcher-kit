#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

OUTDIR="${1:-.}"
mkdir -p "$OUTDIR"
NAME="mitv-$(date +%Y%m%d-%H%M%S).png"
REMOTE="/sdcard/Download/$NAME"
LOCAL="$OUTDIR/$NAME"

adb_tv shell screencap -p "$REMOTE"
adb_tv pull "$REMOTE" "$LOCAL"
adb_tv shell rm -f "$REMOTE" >/dev/null 2>&1 || true

echo "Saved: $LOCAL"
