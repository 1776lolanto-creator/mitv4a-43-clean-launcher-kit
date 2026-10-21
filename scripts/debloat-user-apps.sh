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

cat <<'MSG'
This removes the tested optional Xiaomi apps from user 0 only.
It does not delete APKs from /system.

Packages:
  com.xiaomi.tweather
  com.mitv.alarmcenter
  com.xiaomi.mitv.calendar
  com.xiaomi.mitv.handbook
  com.xiaomi.mitv.shop
  com.mitv.shoplugin
  com.xiaomi.mitv.tvmanager
  com.xiaomi.tv.gallery
  com.xiaomi.voicecontrol
MSG
read -r -p "Type YES to continue: " ans
[[ "$ans" == "YES" ]] || { echo "Cancelled."; exit 0; }

current="$(get_accessibility)"
filtered="$(printf '%s\n' "$current" | tr ':' '\n' \
  | grep -v '^com\.xiaomi\.voicecontrol/com\.xiaomi\.voicecontrol\.VoiceAccessibilityService$' \
  | paste -sd ':' - || true)"
if [[ "$filtered" != "$current" ]]; then
  set_accessibility "$filtered"
fi

for pkg in "${PACKAGES[@]}"; do
  echo "===== $pkg ====="
  if adb_tv shell pm list packages "$pkg" | grep -q "package:$pkg"; then
    adb_tv shell pm uninstall --user 0 "$pkg" || true
  else
    echo "Already absent from user 0"
  fi
done

echo
echo "Remaining target packages:"
adb_tv shell pm list packages | grep -E \
'com\.xiaomi\.tweather|com\.mitv\.alarmcenter|com\.xiaomi\.mitv\.calendar|com\.xiaomi\.mitv\.handbook|com\.xiaomi\.mitv\.shop|com\.mitv\.shopplugin|com\.xiaomi\.mitv\.tvmanager|com\.xiaomi\.tv\.gallery|com\.xiaomi\.voicecontrol' \
|| echo "none"
