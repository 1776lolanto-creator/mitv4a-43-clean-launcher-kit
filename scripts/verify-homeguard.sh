#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

PKG="com.gathin.tvhome"
SERVICE="com.gathin.tvhome/.HomeKeyService"

printf '===== WRITE_SECURE_SETTINGS =====\n'
adb_tv shell dumpsys package "$PKG" \
  | grep -E 'WRITE_SECURE_SETTINGS.*granted=true|WRITE_SECURE_SETTINGS' || true

printf '\n===== enabled accessibility setting =====\n'
get_accessibility

printf '\n===== accessibility runtime =====\n'
adb_tv shell dumpsys accessibility \
  | grep -i -E 'HomeKeyService|com\.gathin\.tvhome|bound|enabled' || true

printf '\n===== recent HomeGuard log =====\n'
adb_tv logcat -d \
  | grep -E 'TvHome\.HomeGuard|MY_PACKAGE_REPLACED|BOOT_COMPLETED' \
  | tail -n 40 || true

printf '\nExpected service: %s\n' "$SERVICE"
