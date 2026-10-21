#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${1:-$ROOT/backups/$STAMP}"
mkdir -p "$OUT"

adb_tv shell getprop > "$OUT/getprop.txt"
adb_tv shell pm list packages -f > "$OUT/packages-f.txt"
adb_tv shell pm list packages -3 > "$OUT/packages-third-party.txt"
adb_tv shell settings get secure enabled_accessibility_services | tr -d '\r' > "$OUT/enabled_accessibility_services.txt"
adb_tv shell dumpsys package com.mitv.tvhome > "$OUT/com.mitv.tvhome-dumpsys.txt" 2>/dev/null || true
adb_tv shell dumpsys package com.gathin.tvhome > "$OUT/com.gathin.tvhome-dumpsys.txt" 2>/dev/null || true
adb_tv shell dumpsys accessibility > "$OUT/accessibility-dumpsys.txt" 2>/dev/null || true

cat > "$OUT/README.txt" <<TXT
MiTV4A backup snapshot
Created: $STAMP
ADB serial: $SERIAL
No passwords or VPN subscription URLs are intentionally collected by this script.
TXT

echo "Backup saved: $OUT"
