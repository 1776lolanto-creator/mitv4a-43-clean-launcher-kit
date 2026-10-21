# Tested final state — v1.1.0

本文件记录 v1.1.0 冻结时的实机终态。

## Boot

经过多次完整重启：

```text
自定义 Launcher → 最多短暂闪一下 → 自定义 Launcher
```

没有完整开机广告，也没有最终落回小米原厂桌面。

## Home takeover

最终实现由两层组成：

1. `HomeKeyService`：拦截物理 `KEYCODE_HOME` / `KEYCODE_ALL_APPS` 并启动自定义 HOME。
2. `HomeGuard`：在 Launcher 启动、开机、APK 覆盖升级后修复 `HomeKeyService` 的无障碍绑定状态。

最终回归测试：

```text
SmartTube → Home                    PASS
full TV reboot → Home              PASS
adb install -r launcher.apk → Home  PASS
```

最后一项没有执行人工 `settings put secure enabled_accessibility_services ...`。

## Permissions

Launcher Manifest 声明并在实机授予：

```text
android.permission.WRITE_SECURE_SETTINGS: granted=true
android.permission.READ_EXTERNAL_STORAGE
```

`WRITE_SECURE_SETTINGS` 的 ADB grant 是否可用取决于 ROM，本项目只确认目标实机有效。

## Accessibility

最终至少保留：

```text
com.xiaomi.mitv.karaoke.service/com.loostone.puremic.voice.service.accessibility.PuremicKeyService
com.gathin.tvhome/.HomeKeyService
```

HomeGuard 在处理自己的服务时会保留其它已配置服务。

## Hidden launcher packages

```text
com.mediatek.wwtv.tvcenter
com.mitv.gallery
com.xiaomi.mitv.systemui
com.xiaomi.mitv.smartshare
```

## Wallpaper

最终主题：

```json
{
  "background_color": "#000000",
  "wallpaper": true,
  "sky_intensity": 0,
  "hidden_apps": [
    "com.mediatek.wwtv.tvcenter",
    "com.mitv.gallery",
    "com.xiaomi.mitv.systemui",
    "com.xiaomi.mitv.smartshare"
  ]
}
```

外部主题读取依赖 `READ_EXTERNAL_STORAGE` grant。
