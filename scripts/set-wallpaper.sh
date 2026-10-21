#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/wallpaper.jpg" >&2
  exit 2
fi

FILE="$1"
[[ -f "$FILE" ]] || { echo "ERROR: file not found: $FILE" >&2; exit 2; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="com.gathin.tvhome"
DIR="/sdcard/Android/data/$PKG/files"
CONFIG="$ROOT/theme/config.json"

# Required on the tested Xiaomi Android 6 ROM.
adb_tv shell pm grant "$PKG" android.permission.READ_EXTERNAL_STORAGE >/dev/null 2>&1 || true

current="$(get_accessibility)"
adb_tv shell mkdir -p "$DIR"
# BitmapFactory decodes by content, so PNG/JPEG source is accepted even though the launcher path is wallpaper.jpg.
adb_tv push "$FILE" "$DIR/wallpaper.jpg"
adb_tv push "$CONFIG" "$DIR/config.json"
adb_tv shell "echo wallpaper-$(date +%s) > $DIR/theme_revision"
adb_tv shell am force-stop "$PKG"
sleep 2
set_accessibility "$current"
adb_tv shell am start -n "$PKG/.MainActivity" >/dev/null

echo "Wallpaper applied: $FILE"
