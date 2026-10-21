# Changelog

## v1.1.0 - 2026-10-21

Home 接管稳定性更新。

- 新增 `HomeGuard` 自愈层
- 新增 `HomeGuardReceiver`，处理 `BOOT_COMPLETED` 与 `MY_PACKAGE_REPLACED`
- Launcher 启动时主动执行一次 HomeGuard 修复
- 新增并实机验证 `WRITE_SECURE_SETTINGS` ADB grant
- 明确 `run-as ... settings` 的 `ACCESS_CONTENT_PROVIDERS_EXTERNALLY` 报错不等于 App 的 Secure Settings 权限无效
- 新增 `scripts/grant-launcher-permissions.sh`
- 新增 `scripts/verify-homeguard.sh`
- 新增 `docs/VALIDATION_MATRIX.md`
- 最终通过 SmartTube Home、完整重启 Home、`install -r` 后 Home 三项回归测试
- 更新恢复、排障、技术说明和最终状态文档

## v1.0.0 - 2026-10-21

首个可公开发布版本，来自 MiTV4A 43 (`matrix`) / Android 6.0.1 实机调试。

- 记录 Xiaomi HOME resolver 限制
- 记录 `com.mitv.tvhome/.BootActivity` 开机广告时序
- 固化 HomeKeyService 的 Home 键和开机回抢方案
- 固化 Android 6 壁纸 `READ_EXTERNAL_STORAGE` / EACCES 修复
- 提供已验证的 user-0 删除包名单
- 保留并隐藏 SystemUI 通知中心、无线投屏
- 增加设备检查、备份、恢复、验证、截图和壁纸脚本
- 增加公开发布需要的 License、Notice、Security、Contributing 和 CI
