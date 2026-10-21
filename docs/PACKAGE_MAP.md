# Package map

以下映射来自实机 `pm list packages -f` 和前台 Activity，不是按中文名猜测。

| 首页名称 | 包名 / 组件 | 最终处理 |
|---|---|---|
| 天气 | `com.xiaomi.tweather` | `pm uninstall --user 0` |
| 定时提醒 | `com.mitv.alarmcenter` | `pm uninstall --user 0` |
| 小爱同学 | `com.xiaomi.voicecontrol` | 先移除其 Accessibility 项，再 user-0 uninstall |
| 日历 | `com.xiaomi.mitv.calendar` | user-0 uninstall |
| 时尚画报 | `com.xiaomi.tv.gallery/.view.GalleryMainActivity` | user-0 uninstall |
| 玩机手册 | `com.xiaomi.mitv.handbook` | user-0 uninstall |
| 电视商城 | `com.xiaomi.mitv.shop` | user-0 uninstall |
| 商城插件 | `com.mitv.shoplugin` | user-0 uninstall |
| 电视管家 | `com.xiaomi.mitv.tvmanager` | user-0 uninstall |
| 通知中心 | `com.xiaomi.mitv.systemui/.notification.notificationcenter.NotificationCenterActivityAlias` | 保留包，仅 Launcher 隐藏 |
| 无线投屏 | `com.xiaomi.mitv.smartshare/.MainActivity` | 保留包，仅 Launcher 隐藏 |
| 原厂 HOME | `com.mitv.tvhome/.MainActivityUserMode` | 保留兜底 |
| 开机广告入口 | `com.mitv.tvhome/.BootActivity` | shell 无权 disable，使用前台回抢 |

## 不要卸载 SystemUI

`com.xiaomi.mitv.systemui` 不只是“通知中心”。为了隐藏一个入口而卸载整个 SystemUI，可能连音量条、系统提示、输入源 UI 一起破坏。
