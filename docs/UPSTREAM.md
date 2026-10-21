# Upstream launcher

本项目使用的 Launcher 源自：

https://github.com/Gathin23/cleanyourtv

Upstream license: MIT.

开发这套 MiTV4A 43 适配时，上游项目正处于快速变化阶段；公开 release `v2.2.0` 发布于 2026-10-19。实机使用的是当时基础上继续做过 API23 和 Xiaomi 行为适配的本地 fork。

因此本仓库选择不复制整份上游源码，避免把一个很快过时的快照伪装成“官方兼容版”。

如果你要复现 Launcher 源码：

1. 从上游获取一个明确版本
2. 先完成 API23 兼容
3. 再应用本仓库 `patches/` 中的设备特定修改
4. 在真机验证 Home、重启、广告时序、壁纸、焦点和设置入口

不要只根据编译成功判断兼容完成。
