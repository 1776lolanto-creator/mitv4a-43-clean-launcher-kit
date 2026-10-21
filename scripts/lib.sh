#!/usr/bin/env bash
set -euo pipefail

ADB="${ADB:-adb}"
TV_HOST="${TV_HOST:-}"
TV_PORT="${TV_PORT:-5555}"

if [[ -z "$TV_HOST" ]]; then
  echo "ERROR: set TV_HOST, e.g. export TV_HOST=192.168.1.50" >&2
  exit 2
fi

SERIAL="$TV_HOST:$TV_PORT"

adb_tv() {
  "$ADB" -s "$SERIAL" "$@"
}

require_device() {
  "$ADB" connect "$SERIAL" >/dev/null 2>&1 || true
  local state
  state="$(adb_tv get-state 2>/dev/null || true)"
  if [[ "$state" != "device" ]]; then
    echo "ERROR: ADB device not available at $SERIAL" >&2
    exit 3
  fi
}

get_accessibility() {
  adb_tv shell settings get secure enabled_accessibility_services | tr -d '\r'
}

set_accessibility() {
  local value="$1"
  adb_tv shell settings put secure enabled_accessibility_services "$value"
  adb_tv shell settings put secure accessibility_enabled 1
}

assert_matrix_api23() {
  local device sdk
  device="$(adb_tv shell getprop ro.product.device | tr -d '\r')"
  sdk="$(adb_tv shell getprop ro.build.version.sdk | tr -d '\r')"
  if [[ "$device" != "matrix" || "$sdk" != "23" ]]; then
    echo "REFUSING: target is ${device:-unknown} / API ${sdk:-unknown}; expected matrix / API 23." >&2
    echo "Set FORCE=1 only after manually validating every package and component." >&2
    [[ "${FORCE:-0}" == "1" ]] || exit 10
  fi
}
