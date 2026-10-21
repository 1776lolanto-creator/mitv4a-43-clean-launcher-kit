# MiTV4A 43 Clean Launcher Kit

针对 **小米电视 MiTV4A 43 中国版，codename `matrix`，Android 6.0.1 / API 23** 的实机改造项目。

目标：**不 root、不刷机、不改 `/system`，把老电视改成一个干净、可控、支持自定义壁纸且 Home 键可长期稳定接管的首页，同时保留原厂系统作为救援层。**

> 当前稳定版：**v1.1.0**  
> 实机：MiTV4A 43 / `matrix` / Android 6.0.1 / build `8.8.20.1275`。  
> 这不是“小米电视通用 Debloat 清单”。型号或 ROM 不同，不要直接执行删除脚本。

## v1.1.0 最重要的变化

v1.0.0 的 `HomeKeyService` 已经可以接管物理 Home 键，但这台 Xiaomi Android 6 ROM 有一个麻烦的状态：APK 更新、`force-stop` 或某些重启流程后，`enabled_accessibility_services` 里可能还写着 `HomeKeyService`，实际服务却没有有效绑定，结果 Home 键又回到小米桌面。

v1.1.0 增加 **HomeGuard 自愈层**：

```text
Launcher / 开机 / APK 覆盖升级
        ↓
HomeGuard 检查 HomeKeyService
        ↓
保留其它无障碍服务
        ↓
只重置并重新加入自己的 HomeKeyService
        ↓
Home 键继续回自定义 Launcher
```

最终已通过三项关键实机测试：

```text
SmartTube 中按 Home                   PASS
电视完整重启后按 Home               PASS
adb install -r 覆盖升级后再按 Home   PASS
```

最后一项测试中**没有手工恢复无障碍服务**。

详见 [`patches/HOME_GUARD.md`](patches/HOME_GUARD.md) 和 [`docs/VALIDATION_MATRIX.md`](docs/VALIDATION_MATRIX.md)。

## 最终效果

```text
开机
→ 自定义 Launcher
→ 最多短暂闪一下
→ 自定义 Launcher
```

并实现：

- 遥控器 Home 键稳定返回自定义 Launcher
- Launcher 覆盖升级后 Home 接管可自行恢复
- 完整重启后 Home 接管保持可用
- 原厂开机广告不再完整播放
- 广告结束后不会最终落回小米原厂桌面
- 删除天气、提醒、日历、商城、电视管家、时尚画报、小爱同学等不需要的 user-0 预装 App
- `SystemUI` 与无线投屏继续保留，但相关入口不显示在自定义首页
- 支持 JPG/PNG 自定义壁纸
- 提供 ADB 截图、前台包名识别、状态检查、备份和恢复工具

## 已验证设备

| 项目 | 实机值 |
|---|---|
| 型号 | Xiaomi MiTV4A 43 |
| codename | `matrix` |
| Android | 6.0.1 |
| API | 23 |
| ABI | `armeabi-v7a` |
| CPU | 4× Cortex-A53，约 1.5 GHz |
| RAM | 2 GB |
| 存储 | 8 GB eMMC |
| 小米 UI | 1.3.85 stable |
| build | `8.8.20.1275` |
| Launcher 包名 | `com.gathin.tvhome` |

## 这个项目解决的四个特殊问题

### 1. 第三方 Launcher 无法成为标准 HOME

这台 ROM 对 `MAIN + HOME` 做了 Xiaomi 自定义过滤。普通第三方 Launcher 即使声明 HOME，也不会像标准 Android 那样通过 chooser 成为默认桌面。

因此方案使用 `AccessibilityService` 接管遥控器 Home 键，并显式拉起 `com.gathin.tvhome`。详见 [`patches/HOME_TAKEOVER.md`](patches/HOME_TAKEOVER.md)。

### 2. HomeKeyService 会出现“配置还在、实际失效”

这是 v1.1.0 重点解决的问题。Launcher 声明并由 ADB 一次性授予：

```text
android.permission.WRITE_SECURE_SETTINGS
```

随后 HomeGuard 通过应用自身的 `ContentResolver` 修复无障碍服务状态。详见 [`patches/HOME_GUARD.md`](patches/HOME_GUARD.md)。

### 3. 开机广告晚于 Launcher 启动

实测 `com.mitv.tvhome/.BootActivity` 会在自定义 Launcher 已出现后才启动并覆盖前台。因此本机保留开机前 45 秒内的多时间点回抢：

```text
0.5s / 8s / 15s / 25s / 35s / 45s
```

这些时间点来自本机日志，不建议原样复制到其它型号。

### 4. Android 6 壁纸主题读取 EACCES

Launcher 从：

```text
/storage/emulated/0/Android/data/com.gathin.tvhome/files/
```

读取 `config.json` / `wallpaper.jpg`，本机最初会得到：

```text
open failed: EACCES (Permission denied)
```

需要声明并 ADB 授权 `READ_EXTERNAL_STORAGE`。详见 [`patches/STORAGE_PERMISSION.md`](patches/STORAGE_PERMISSION.md)。

## 项目结构

```text
.
├── VERSION
├── README.md
├── README.en.md
├── QUICKSTART.md
├── CHANGELOG.md
├── LICENSE
├── NOTICE.md
├── scripts/
│   ├── check-device.sh
│   ├── backup-state.sh
│   ├── grant-launcher-permissions.sh
│   ├── verify-homeguard.sh
│   ├── debloat-user-apps.sh
│   ├── restore-packages.sh
│   ├── restore-accessibility.sh
│   ├── verify-final-state.sh
│   ├── identify-foreground.sh
│   ├── apply-theme.sh
│   ├── set-wallpaper.sh
│   ├── install-apk.sh
│   └── screenshot.sh
├── theme/
│   └── config.json
├── patches/
│   ├── HOME_TAKEOVER.md
│   ├── HOME_GUARD.md
│   ├── STORAGE_PERMISSION.md
│   ├── API23_NOTES.md
│   └── homeguard/
│       ├── HomeGuard.java
│       └── HomeGuardReceiver.java
└── docs/
    ├── PACKAGE_MAP.md
    ├── TECHNICAL_NOTES.md
    ├── TESTED_STATE.md
    ├── VALIDATION_MATRIX.md
    ├── RECOVERY.md
    ├── TROUBLESHOOTING.md
    └── UPSTREAM.md
```

## 快速开始

先阅读 [`QUICKSTART.md`](QUICKSTART.md)。典型环境变量：

```bash
export ADB="$HOME/Downloads/platform-tools/adb"
export TV_HOST="192.168.1.50"
```

检查设备：

```bash
./scripts/check-device.sh
```

先备份：

```bash
./scripts/backup-state.sh
```

## Launcher 必需补丁

你的 API 23 `com.gathin.tvhome` fork 至少需要：

1. [`patches/HOME_TAKEOVER.md`](patches/HOME_TAKEOVER.md)
2. [`patches/HOME_GUARD.md`](patches/HOME_GUARD.md)
3. [`patches/STORAGE_PERMISSION.md`](patches/STORAGE_PERMISSION.md)
4. [`patches/API23_NOTES.md`](patches/API23_NOTES.md)

安装后执行一次：

```bash
./scripts/grant-launcher-permissions.sh
```

其中 `WRITE_SECURE_SETTINGS` 的 ADB grant 是本机 ROM 上验证过的设备特定行为。

## 已验证可从 user 0 移除的包

| 首页名称 | 包名 |
|---|---|
| 天气 | `com.xiaomi.tweather` |
| 定时提醒 | `com.mitv.alarmcenter` |
| 日历 | `com.xiaomi.mitv.calendar` |
| 玩机手册 | `com.xiaomi.mitv.handbook` |
| 电视商城 | `com.xiaomi.mitv.shop` |
| 商城插件 | `com.mitv.shoplugin` |
| 电视管家 | `com.xiaomi.mitv.tvmanager` |
| 时尚画报 | `com.xiaomi.tv.gallery` |
| 小爱同学 / 语音控制 | `com.xiaomi.voicecontrol` |

执行：

```bash
./scripts/debloat-user-apps.sh
```

脚本会检查 `matrix / API 23`，并要求输入 `YES`。

## 保留但隐藏

不要卸载：

```text
com.xiaomi.mitv.systemui
com.xiaomi.mitv.smartshare
```

原因：前者不只是通知中心，后者是无线投屏功能。本项目通过 [`theme/config.json`](theme/config.json) 的 `hidden_apps` 隐藏 Launcher 入口。

## 壁纸

完成存储权限补丁后：

```bash
./scripts/set-wallpaper.sh /path/to/photo.jpg
```

推荐 1920×1080 / 16:9。Launcher 使用 `CENTER_CROP`。

## 截图

本机 `adb exec-out screencap -p > file.png` 曾产生无法打开的文件，因此固定使用“电视先写文件，再 pull”：

```bash
./scripts/screenshot.sh ~/Desktop
```

## 安全边界

本项目刻意不做：

- root
- remount `/system`
- 删除原厂 `com.mitv.tvhome`
- 卸载 `com.xiaomi.mitv.systemui`
- 试图突破 uid=1000 系统组件状态保护

原厂 `com.mitv.tvhome/.MainActivityUserMode` 保留为救援层。

## 关于 Launcher 源码

本仓库是设备适配 companion kit，不重新分发上游 Launcher 完整源码。实机使用的是一个已经完成 API23 与 Xiaomi 行为适配的本地 fork。

为提高 v1.1.0 的可复现性，本仓库现在附带 **HomeGuard 的完整新增 Java 类**，但仍不声称对任意上游 commit 可直接无冲突应用。

上游与许可证见 [`NOTICE.md`](NOTICE.md) / [`docs/UPSTREAM.md`](docs/UPSTREAM.md)。

## GitHub 发布信息

Description：

> No-root clean launcher, self-healing Home takeover, debloat, wallpaper and ADB toolkit for Xiaomi MiTV4A 43 (matrix), Android 6.0.1 / API 23.

Topics：

```text
xiaomi-tv mitv mitv4a android-tv android-6 adb launcher debloat
```

## License

本仓库原创脚本与文档使用 MIT License。第三方项目版权归各自权利人所有。
