#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/app.apk" >&2
  exit 2
fi

APK="$1"
[[ -f "$APK" ]] || { echo "ERROR: APK not found: $APK" >&2; exit 2; }
adb_tv install -r "$APK"
