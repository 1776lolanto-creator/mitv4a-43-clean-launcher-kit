#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

PKG="com.gathin.tvhome"

if ! adb_tv shell pm list packages "$PKG" | grep -q "package:$PKG"; then
  echo "ERROR: $PKG is not installed." >&2
  exit 4
fi

echo "Granting tested MiTV4A launcher permissions..."
adb_tv shell pm grant "$PKG" android.permission.WRITE_SECURE_SETTINGS
adb_tv shell pm grant "$PKG" android.permission.READ_EXTERNAL_STORAGE

echo
echo "Relevant package permission state:"
adb_tv shell dumpsys package "$PKG" \
  | grep -n -A 4 -B 4 -E 'WRITE_SECURE_SETTINGS|READ_EXTERNAL_STORAGE' || true
