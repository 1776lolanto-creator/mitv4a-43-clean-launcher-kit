# MiTV4A 43 Clean Launcher Kit

针对 **小米电视 MiTV4A 43 中国版，codename `matrix`，Android 6.0.1 / API 23** 的实机改造项目。

目标很明确：**不 root、不刷机、不改 `/system`，把老电视改成一个干净、可控、能自定义壁纸的首页，同时保留原厂系统作为兜底。**

> 状态：`v1.0.0`，在一台 MiTV4A 43 / `matrix` / build `8.8.20.1275` 上完成实机验证。
> 这不是“所有小米电视通用脚本”。型号或系统版本不同，先做识别，不要直接执行删除脚本。

## 最终效果

实机最终行为：

```text
开机
→ 自定义 Launcher
→ 最多短暂闪一下
→ 自定义 Launcher
```

并实现：

- 遥控器 Home 键返回自定义 Launcher
- 原厂开机广告不再完整播放
- 广告结束后不会掉回小米原厂桌面
- 删除天气、提醒、日历、商城、电视管家、时尚画报、小爱同学等不需要的预装 App
- `SystemUI` 和无线投屏功能继续保留，但相关入口不出现在自定义首页
- 支持自定义 JPG/PNG 壁纸
- 提供稳定的 ADB 截图、前台包名识别、状态检查和恢复脚本

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

## 这个项目解决的三个特殊问题

### 1. 第三方 Launcher 无法成为标准 HOME

这台 ROM 对 `MAIN + HOME` 做了 Xiaomi 自定义过滤。普通第三方 Launcher 即使声明 HOME，也不会像标准 Android 那样通过 chooser 成为默认桌面。

因此本方案不和 Xiaomi 的 HOME resolver 硬碰，而是使用 `AccessibilityService` 接管遥控器 Home 键，并显式拉起 `com.gathin.tvhome`。

### 2. 开机广告晚于 Launcher 启动

实测中，自定义 Launcher 已经出现后，`com.mitv.tvhome/.BootActivity` 还会在十几秒后启动并覆盖前台。因此仅“开机拉起一次 Launcher”不够。

本机最终采用开机前 45 秒内的多时间点回抢：

```text
0.5s / 8s / 15s / 25s / 35s / 45s
```

这套数字来自本机日志，不建议照搬到其它型号。

### 3. Android 6 壁纸主题会报 EACCES

Launcher 从：

```text
/storage/emulated/0/Android/data/com.gathin.tvhome/files/
```

读取 `config.json` 和 `wallpaper.jpg`，但本机应用进程最初会收到：

```text
open failed: EACCES (Permission denied)
```

需要在 Launcher Manifest 声明 `READ_EXTERNAL_STORAGE`，安装后再用 ADB `pm grant` 授权。详见 [`patches/STORAGE_PERMISSION.md`](patches/STORAGE_PERMISSION.md)。

## 项目结构

```text
.
├── README.md
├── README.en.md
├── QUICKSTART.md
├── CHANGELOG.md
├── LICENSE
├── NOTICE.md
├── scripts/
│   ├── lib.sh
│   ├── check-device.sh
│   ├── backup-state.sh
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
│   ├── STORAGE_PERMISSION.md
│   └── API23_NOTES.md
└── docs/
    ├── PACKAGE_MAP.md
    ├── TECHNICAL_NOTES.md
    ├── TESTED_STATE.md
    ├── RECOVERY.md
    ├── TROUBLESHOOTING.md
    └── UPSTREAM.md
```

## 快速开始

先阅读 [`QUICKSTART.md`](QUICKSTART.md)。最基本的环境变量：

```bash
export ADB="$HOME/Downloads/platform-tools/adb"
export TV_HOST="192.168.1.50"
```

检查连接和目标机：

```bash
./scripts/check-device.sh
```

先备份当前状态：

```bash
./scripts/backup-state.sh
```

再进行任何删除操作。

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

脚本会再次检查 `matrix / API 23`，并要求输入 `YES` 才执行。

`pm uninstall --user 0` 只针对当前用户，不会直接删除 `/system` 中的 APK。

## 保留但隐藏的入口

这两个包**不要卸载**：

```text
com.xiaomi.mitv.systemui
com.xiaomi.mitv.smartshare
```

原因：

- `com.xiaomi.mitv.systemui` 包含通知中心，但也可能承载音量条、系统提示、输入源 UI
- `com.xiaomi.mitv.smartshare` 是无线投屏，本项目只要求首页不显示，不要求破坏投屏能力

它们通过 [`theme/config.json`](theme/config.json) 的 `hidden_apps` 从 Launcher 网格隐藏。

## 自定义壁纸

Launcher 完成 Android 6 存储权限补丁后：

```bash
./scripts/set-wallpaper.sh /path/to/photo.jpg
```

推荐：

```text
1920×1080
16:9
JPG
```

Launcher 使用 `CENTER_CROP`，所以主体不要贴近边缘。

## 截图

本机 `adb exec-out screencap -p > file.png` 曾生成无法打开的 PNG，因此项目固定采用“电视先写文件，再 pull”：

```bash
./scripts/screenshot.sh ~/Desktop
```

## 安全边界

本项目刻意**没有**：

- root
- remount `/system`
- 删除原厂 `com.mitv.tvhome`
- 卸载 `com.xiaomi.mitv.systemui`
- 尝试绕过 uid=1000 的系统组件保护

原厂 HOME `com.mitv.tvhome/.MainActivityUserMode` 保留作为救援层。

## Launcher 上游

本项目围绕 Gathin23 的开源 `cleanyourtv` Launcher 做设备适配，但不重新分发其完整源码。详情和许可证见 [`NOTICE.md`](NOTICE.md) 与 [`docs/UPSTREAM.md`](docs/UPSTREAM.md)。

本机使用的是一个已经适配 API 23 的本地 fork。上游后续版本可能已经变化，因此**不要假设当前 main 分支可直接在 Android 6 上编译运行**。

## 发布建议

GitHub Description：

> No-root clean launcher, debloat, wallpaper and ADB toolkit for Xiaomi MiTV4A 43 (matrix), Android 6.0.1 / API 23.

Topics：

```text
xiaomi-tv mitv mitv4a android-tv android-6 adb launcher debloat
```

## License

本仓库脚本和文档使用 MIT License。上游 `cleanyourtv` 同样使用 MIT License，但本仓库不包含其完整源码或字体资源。
