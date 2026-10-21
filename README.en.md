# MiTV4A 43 Clean Launcher Kit

A device-specific, no-root companion kit for the **Xiaomi MiTV4A 43 China model** (`matrix`) running **Android 6.0.1 / API 23**.

Current stable release: **v1.1.0**.

The setup validated on one physical TV keeps Xiaomi's stock launcher as a recovery layer while adding:

- physical Home-key takeover through `HomeKeyService`;
- a v1.1.0 **HomeGuard** self-healing layer for reboot and `install -r` updates;
- Xiaomi delayed boot-ad foreground recovery;
- user-0 removal of selected optional Xiaomi apps;
- hidden SystemUI notification-center and wireless-casting tiles without removing those system packages;
- custom wallpaper support with the Android 6 storage permission fix;
- ADB backup, verification, foreground-app identification, and reliable screenshots.

The final Home takeover passed:

```text
SmartTube → Home                    PASS
full reboot → Home                  PASS
adb install -r launcher.apk → Home  PASS
```

No manual accessibility repair was used after the package-update test.

This is **not a universal Xiaomi TV debloat list**. Destructive scripts refuse to proceed by default unless the target reports `ro.product.device=matrix` and API 23.

Start with [`QUICKSTART.md`](QUICKSTART.md). HomeGuard implementation details are in [`patches/HOME_GUARD.md`](patches/HOME_GUARD.md).

## Upstream launcher

The tested setup is based on the MIT-licensed `cleanyourtv` launcher by Gathin23. This repository does not vendor the complete upstream source or font assets. It includes only the device-specific companion scripts, documentation, and the new HomeGuard classes required by this adaptation.

See [`NOTICE.md`](NOTICE.md) and [`docs/UPSTREAM.md`](docs/UPSTREAM.md).

## License

Original scripts and documentation in this repository are MIT licensed.
