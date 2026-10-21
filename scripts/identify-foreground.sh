#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
require_device

adb_tv shell 'dumpsys activity activities | grep -m 1 "mResumedActivity"; dumpsys window windows | grep -E "mCurrentFocus|mFocusedApp"'
