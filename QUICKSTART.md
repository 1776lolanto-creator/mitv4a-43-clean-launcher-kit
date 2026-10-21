# Quick start — v1.1.0

这是给已经确认设备为 **MiTV4A 43 / `matrix` / Android 6.0.1 API 23** 的用户准备的最短流程。

## 1. ADB

电视开启开发者选项和 ADB 调试。电脑准备 Android Platform Tools：

```bash
export ADB="$HOME/Downloads/platform-tools/adb"
export TV_HOST="192.168.1.50"
"$ADB" connect "$TV_HOST:5555"
```

## 2. 识别型号

```bash
./scripts/check-device.sh
```

只有看到：

```text
Target check: PASS (matrix / API 23)
```

才继续。

## 3. 备份

```bash
./scripts/backup-state.sh
```

## 4. 准备 Launcher

本项目不附带上游 Launcher 完整源码。你的 `com.gathin.tvhome` API23 fork 需要应用：

- [`patches/HOME_TAKEOVER.md`](patches/HOME_TAKEOVER.md)
- [`patches/HOME_GUARD.md`](patches/HOME_GUARD.md)
- [`patches/STORAGE_PERMISSION.md`](patches/STORAGE_PERMISSION.md)
- [`patches/API23_NOTES.md`](patches/API23_NOTES.md)

HomeGuard 新增类已经放在：

```text
patches/homeguard/HomeGuard.java
patches/homeguard/HomeGuardReceiver.java
```

编译、安装 Launcher 后，一次性授予本机验证过的权限：

```bash
./scripts/grant-launcher-permissions.sh
```

首次安装仍建议确保 HomeKeyService 至少启用一次：

```bash
./scripts/restore-accessibility.sh
```

HomeGuard 生效后，后续普通重启和 `install -r` 更新不应再需要人工恢复。

## 5. 验证 HomeGuard

```bash
./scripts/verify-homeguard.sh
```

然后做三项实机测试：

```text
任意 App（如 SmartTube）→ Home
完整重启 → Home
adb install -r 当前 Launcher APK → Home
```

三项都应回到自定义 Launcher。

## 6. 删除已验证的可选预装 App

```bash
./scripts/debloat-user-apps.sh
```

输入 `YES` 后才会执行。

## 7. 应用主题 / 壁纸

```bash
./scripts/apply-theme.sh
./scripts/set-wallpaper.sh /path/to/wallpaper.jpg
```

最终主题默认隐藏通知中心入口和无线投屏入口，但不会卸载对应系统包。

## 8. 最终验证

```bash
./scripts/verify-final-state.sh
```

预期启动体验：

```text
开机 → 自定义 Launcher → 最多短暂闪屏 → 自定义 Launcher
```
