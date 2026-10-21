# Self-healing Home takeover (v1.1.0)

`v1.0.0` proved that `HomeKeyService` can route the physical Home key to the custom launcher, but Xiaomi's Android 6 build can silently detach the accessibility service after an APK update, force-stop, or reboot. The secure setting can even still contain the service name while the service is no longer effectively bound.

`v1.1.0` adds a small self-healing layer called **HomeGuard**.

## What it does

On the tested MiTV4A 43 / `matrix` build, HomeGuard:

1. reads `Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES`;
2. preserves every existing accessibility service except its own entry;
3. briefly removes and re-adds `com.gathin.tvhome/.HomeKeyService`;
4. ensures `Settings.Secure.ACCESSIBILITY_ENABLED=1`;
5. runs once per launcher process;
6. runs again after `BOOT_COMPLETED` and `MY_PACKAGE_REPLACED`.

This specifically fixes the previously observed failure mode:

```text
HomeKeyService still appears in secure settings
→ physical Home goes to Xiaomi launcher anyway
```

## Required manifest permissions

Add these to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_SECURE_SETTINGS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

The wallpaper patch still requires:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## Receiver

Inside `<application>`:

```xml
<receiver
    android:name=".HomeGuardReceiver"
    android:enabled="true"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
    </intent-filter>
</receiver>
```

Reference implementations are included in:

```text
patches/homeguard/HomeGuard.java
patches/homeguard/HomeGuardReceiver.java
```

Copy them into the launcher's `com.gathin.tvhome` package.

## MainActivity hook

Immediately after `super.onCreate(savedInstanceState)`:

```java
HomeGuard.repairOnce(this);
```

The MainActivity hook is important. It gives the launcher a direct recovery path even if a broadcast is delayed or missed.

## One-time ADB grant

After installing the launcher build that declares the permission:

```bash
adb shell pm grant \
  com.gathin.tvhome \
  android.permission.WRITE_SECURE_SETTINGS
```

On the tested ROM the grant is visible in `dumpsys package` as:

```text
android.permission.WRITE_SECURE_SETTINGS: granted=true
```

This behavior is device/ROM specific. Do not assume other Android builds allow the same grant.

For the wallpaper path also grant:

```bash
adb shell pm grant \
  com.gathin.tvhome \
  android.permission.READ_EXTERNAL_STORAGE
```

Or use:

```bash
./scripts/grant-launcher-permissions.sh
```

## Important test detail

Do **not** test this with:

```bash
run-as com.gathin.tvhome settings put secure ...
```

The Android `settings` command-line client itself uses an external SettingsProvider access path and can fail with `ACCESS_CONTENT_PROVIDERS_EXTERNALLY` even when the app's `WRITE_SECURE_SETTINGS` permission is actually granted.

The launcher uses its own `ContentResolver` and `Settings.Secure.putString()/putInt()` APIs instead.

## Validation matrix

The final v1.1.0 implementation passed all three on the physical TV:

```text
SmartTube → Home                   PASS
full TV reboot → Home             PASS
adb install -r launcher.apk → Home PASS
```

No manual `settings put secure enabled_accessibility_services ...` command was used after the update test.
