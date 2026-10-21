#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

SERVICE="com.gathin.tvhome/.HomeKeyService"
current="$(get_accessibility)"

if [[ "$current" == *"$SERVICE"* ]]; then
  echo "HomeKeyService already enabled."
  exit 0
fi

if [[ -z "$current" || "$current" == "null" ]]; then
  new="$SERVICE"
else
  new="$current:$SERVICE"
fi

set_accessibility "$new"
echo "Enabled: $SERVICE"
get_accessibility
