#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

PKG="com.gathin.tvhome"
DIR="/sdcard/Android/data/$PKG/files"

echo "===== device ====="
adb_tv shell getprop ro.product.device | tr -d '\r'
adb_tv shell getprop ro.build.version.sdk | tr -d '\r'

echo
echo "===== launcher ====="
adb_tv shell pm list packages "$PKG" | tr -d '\r'

echo
echo "===== launcher permissions ====="
adb_tv shell dumpsys package "$PKG" \
  | grep -E 'WRITE_SECURE_SETTINGS.*granted=true|READ_EXTERNAL_STORAGE|WRITE_SECURE_SETTINGS' || true

echo
echo "===== accessibility setting ====="
get_accessibility

echo
echo "===== accessibility runtime ====="
adb_tv shell dumpsys accessibility \
  | grep -i -E 'HomeKeyService|com\.gathin\.tvhome' || true

echo
echo "===== HomeGuard recent log ====="
adb_tv logcat -d | grep 'TvHome.HomeGuard' | tail -n 20 || true

echo
echo "===== theme ====="
adb_tv shell cat "$DIR/config.json" 2>/dev/null || echo "config.json unavailable"

echo
echo "===== removed-app check ====="
TARGET_RE='com\.xiaomi\.tweather|com\.mitv\.alarmcenter|com\.xiaomi\.mitv\.calendar|com\.xiaomi\.mitv\.handbook|com\.xiaomi\.mitv\.shop|com\.mitv\.shopplugin|com\.xiaomi\.mitv\.tvmanager|com\.xiaomi\.tv\.gallery|com\.xiaomi\.voicecontrol'
adb_tv shell pm list packages | grep -E "$TARGET_RE" || echo "tested optional packages absent from user 0"

echo
echo "===== protected packages that should remain ====="
for p in com.mitv.tvhome com.xiaomi.mitv.systemui com.xiaomi.mitv.smartshare; do
  adb_tv shell pm list packages "$p" | grep "package:$p" || echo "WARNING: $p missing"
done
