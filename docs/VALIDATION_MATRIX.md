# v1.1.0 validation matrix

Final Home takeover was frozen only after these tests passed on the physical MiTV4A 43 (`matrix`) running Android 6.0.1 / API 23.

| Scenario | Result | Notes |
|---|---:|---|
| Launcher already running, open SmartTube, press Home | PASS | Returned directly to `com.gathin.tvhome` |
| Full TV reboot, then press Home | PASS | Home takeover remained functional |
| `adb install -r` the same launcher APK, wait, open SmartTube, press Home | PASS | No manual accessibility repair required |
| Wallpaper config read from external app files | PASS | After `READ_EXTERNAL_STORAGE` grant |
| Boot-ad window | PASS | No full ad playback; custom launcher regains foreground |
| Xiaomi stock launcher kept as recovery layer | PASS | `com.mitv.tvhome` remains installed |

The third test is the important v1.1.0 regression test. Earlier builds could appear correct after reboot but lose physical Home takeover after a launcher update.
