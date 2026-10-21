#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device
assert_matrix_api23

PACKAGES=(
  com.xiaomi.tweather
  com.mitv.alarmcenter
  com.xiaomi.mitv.calendar
  com.xiaomi.mitv.handbook
  com.xiaomi.mitv.shop
  com.mitv.shoplugin
  com.xiaomi.mitv.tvmanager
  com.xiaomi.tv.gallery
  com.xiaomi.voicecontrol
)

if ! adb_tv shell cmd package help >/dev/null 2>&1; then
  echo "This ROM does not expose a usable 'cmd package' interface." >&2
  echo "Automatic restore is unavailable; factory reset remains the reliable fallback." >&2
  exit 4
fi

for pkg in "${PACKAGES[@]}"; do
  echo "===== $pkg ====="
  adb_tv shell cmd package install-existing "$pkg" || true
done

echo "Restore attempt finished. Re-check packages and reboot before relying on restored apps."
