# Troubleshooting

## Home suddenly returns to Xiaomi launcher

v1.1.0 首先检查 HomeGuard：

```bash
./scripts/verify-homeguard.sh
```

应确认：

```text
android.permission.WRITE_SECURE_SETTINGS: granted=true
com.gathin.tvhome/.HomeKeyService
```

并在日志中寻找：

```text
TvHome.HomeGuard: Home accessibility repaired
```

如果 `WRITE_SECURE_SETTINGS` 未授予：

```bash
./scripts/grant-launcher-permissions.sh
```

如果 Launcher 还是旧版、没有 HomeGuard，则临时回退：

```bash
./scripts/restore-accessibility.sh
```

## `run-as com.gathin.tvhome settings put secure ...` fails

可能看到：

```text
requires android.permission.ACCESS_CONTENT_PROVIDERS_EXTERNALLY
```

这不能用来判断 HomeGuard 是否有 `WRITE_SECURE_SETTINGS`。Android 的 `settings` CLI 走的是额外的 provider-external 路径。检查：

```bash
adb shell dumpsys package com.gathin.tvhome \
  | grep -n -A 4 -B 4 WRITE_SECURE_SETTINGS
```

HomeGuard 本身使用 App 的 `ContentResolver`。

## Theme config does nothing

用高对比测试：

```json
{
  "background_color": "#FF00FF",
  "wallpaper": false,
  "sky_intensity": 0
}
```

如果仍无变化：

```bash
adb logcat -d | grep -E 'TvHome\.Config|config\.json|wallpaper\.jpg'
```

本机曾出现 `EACCES (Permission denied)`，见 `patches/STORAGE_PERMISSION.md`。

## Screenshot cannot be opened

不要依赖：

```bash
adb exec-out screencap -p > screenshot.png
```

本机曾得到损坏文件。使用：

```bash
./scripts/screenshot.sh ~/Desktop
```

## Boot ad finishes and stock home remains

确认 `HomeKeyService` 包含 45 秒保险回抢点，并运行：

```bash
./scripts/verify-homeguard.sh
```

## `pm disable-user` returns Permission Denial

对 uid=1000 的系统组件不要继续轮番尝试 `pm hide`、`cmd package` 等。该 ROM 限制 shell 修改系统组件状态。使用“保留系统包 + Launcher 隐藏”或 Home takeover。
