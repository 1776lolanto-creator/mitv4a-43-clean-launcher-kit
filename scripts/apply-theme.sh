#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${1:-$ROOT/theme/config.json}"
PKG="com.gathin.tvhome"
DIR="/sdcard/Android/data/$PKG/files"

[[ -f "$CONFIG" ]] || { echo "ERROR: config not found: $CONFIG" >&2; exit 2; }
python3 -m json.tool "$CONFIG" >/dev/null

current="$(get_accessibility)"
adb_tv shell mkdir -p "$DIR"
adb_tv push "$CONFIG" "$DIR/config.json"
adb_tv shell "echo theme-$(date +%s) > $DIR/theme_revision"
adb_tv shell am force-stop "$PKG"
sleep 2
set_accessibility "$current"
adb_tv shell am start -n "$PKG/.MainActivity" >/dev/null

echo "Theme applied: $CONFIG"
