# MiTV4A 43 Clean Launcher Kit v1.1.0

This release turns the Home-key takeover from a manually recoverable setup into a self-healing one on the tested Xiaomi MiTV4A 43 (`matrix`) Android 6.0.1 firmware.

## Highlights

- adds `HomeGuard` and `HomeGuardReceiver`;
- self-repairs `HomeKeyService` after boot, launcher process start, and `install -r` package replacement;
- documents and verifies the device-specific `WRITE_SECURE_SETTINGS` ADB grant;
- preserves all other accessibility services while re-toggling only the custom launcher's service;
- keeps the existing delayed boot-ad recovery, debloat list, wallpaper fix, hidden SystemUI/casting tiles, and recovery layer.

## Regression tests passed on hardware

```text
SmartTube → Home                    PASS
full TV reboot → Home              PASS
adb install -r launcher.apk → Home  PASS
```

The package-update test required no manual accessibility repair.

## Upgrade from v1.0.0

Apply `patches/HOME_GUARD.md`, rebuild/install the launcher, then run:

```bash
./scripts/grant-launcher-permissions.sh
./scripts/restore-accessibility.sh   # first-time safety step only
./scripts/verify-homeguard.sh
```

After that, validate the three scenarios above before relying on the setup.
