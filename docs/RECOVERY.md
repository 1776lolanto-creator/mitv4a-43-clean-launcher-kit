# Recovery

## Home key no longer returns to the custom launcher

v1.1.0：

```bash
./scripts/verify-homeguard.sh
```

若权限丢失：

```bash
./scripts/grant-launcher-permissions.sh
```

启动 Launcher 一次，HomeGuard 会重新写入自己的 AccessibilityService 状态。

旧版或紧急手工回退：

```bash
./scripts/restore-accessibility.sh
```

## Theme/wallpaper breaks the home screen

删除外部主题：

```bash
adb shell rm -f \
  /sdcard/Android/data/com.gathin.tvhome/files/config.json \
  /sdcard/Android/data/com.gathin.tvhome/files/wallpaper.jpg \
  /sdcard/Android/data/com.gathin.tvhome/files/theme_revision
```

然后重新启动 Launcher。

## Custom launcher crashes

原厂 HOME 没有删除：

```text
com.mitv.tvhome/.MainActivityUserMode
```

它是项目刻意保留的救援层。

## Full uninstall / factory reset

`install -r` 已验证 HomeGuard 可自愈；但如果完整卸载 Launcher、清除应用数据或恢复出厂设置，重新安装后应再次执行：

```bash
./scripts/grant-launcher-permissions.sh
./scripts/restore-accessibility.sh
```

## Restore user-0 removed packages

先尝试：

```bash
./scripts/restore-packages.sh
```

部分 Android 6 ROM 可能不支持 `cmd package install-existing`。如果必须恢复系统预装 App 而 ROM 不支持该命令，可靠兜底仍是恢复出厂设置。
