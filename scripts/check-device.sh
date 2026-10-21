#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

printf 'ADB serial: %s\n\n' "$SERIAL"
for p in \
  ro.product.manufacturer \
  ro.product.model \
  ro.product.device \
  ro.build.version.release \
  ro.build.version.sdk \
  ro.build.display.id \
  ro.product.cpu.abi; do
  printf '%-28s ' "$p"
  adb_tv shell getprop "$p" | tr -d '\r'
done

echo
DEVICE="$(adb_tv shell getprop ro.product.device | tr -d '\r')"
SDK="$(adb_tv shell getprop ro.build.version.sdk | tr -d '\r')"

if [[ "$DEVICE" == "matrix" && "$SDK" == "23" ]]; then
  echo "Target check: PASS (matrix / API 23)"
else
  echo "Target check: WARNING"
  echo "Validated target is MiTV4A 43 codename matrix, Android 6.0.1 / API 23."
fi
