# Technical notes

## Xiaomi HOME selection

实机反查表明，ROM 处理 `MAIN + HOME` 时会优先保留系统应用或 Xiaomi 允许的第三方 HOME。因此标准 preferred-activity/chooser 在本机无效。

这也是本项目为什么不把“设默认 Launcher”当成普通 Android 教程处理。

## Home takeover architecture in v1.1.0

```text
physical HOME key
      ↓
HomeKeyService (AccessibilityService)
      ↓
explicit start of com.gathin.tvhome

boot / package update / launcher process start
      ↓
HomeGuard
      ↓
Settings.Secure via ContentResolver
      ↓
re-toggle only com.gathin.tvhome/.HomeKeyService
      ↓
preserve all other accessibility entries
```

HomeGuard exists because the tested Xiaomi Android 6 ROM can leave the service name in `enabled_accessibility_services` while the actual service binding is ineffective.

The tested ROM allowed an ADB grant of `android.permission.WRITE_SECURE_SETTINGS` after the permission was declared in the launcher manifest. `dumpsys package` reported `granted=true`.

This must be treated as device-specific behavior, not a general Android guarantee.

## Why the `run-as ... settings` test is misleading

Running:

```bash
run-as com.gathin.tvhome settings put secure ...
```

failed with a requirement for `ACCESS_CONTENT_PROVIDERS_EXTERNALLY`. That error comes from the Android command-line `settings` client calling an external provider path. It does not negate the app's own `WRITE_SECURE_SETTINGS` grant.

The launcher uses `Settings.Secure.putString()/putInt()` through its own `ContentResolver`.

## Boot timeline from one captured boot

```text
10:04:47.613  com.mitv.tvhome/.MainActivityUserMode starts
10:04:48.318  com.gathin.tvhome HomeKeyService process starts
10:04:48.866  custom launcher starts
10:04:59.138  com.miui.systemAdSolution AdReceiver process starts
10:05:00.749  com.mitv.tvhome/.BootActivity starts
10:05:02.096  BootActivity.sendAdShowBroadcast (onCreate)
10:05:23.545  BootActivity.sendAdShowBroadcast (onDestroy)
```

因此“开机只拉一次自定义 Launcher”会失败。

## `com.miui.systemAdSolution`

它参与广告链路，但前台真正启动并覆盖 Launcher 的 Activity 是：

```text
com.mitv.tvhome/.BootActivity
```

## Why BootActivity is not disabled

```bash
pm disable-user --user 0 com.mitv.tvhome/.BootActivity
```

实机返回：

```text
SecurityException: Permission Denial: attempt to change component state ... uid=2000, package uid=1000
```

通知中心 ActivityAlias 也受到同类保护。

## Wallpaper rendering

Launcher 的 `showWallpaper(File)`：

- BitmapFactory 解码
- 按屏幕尺寸 downsample
- RGB_565 降低内存
- ImageView 使用 `CENTER_CROP`
- 插入 root index 0

因此推荐 16:9 构图。
