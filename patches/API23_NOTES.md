# API 23 compatibility notes

目标电视运行 Android 6.0.1 / API 23。

本机最终使用的是一个已经适配 API 23 的 `com.gathin.tvhome` 本地 fork。适配工作不仅是把 `minSdk` 数字改成 23，还需要检查源码中 API 24/26+ 调用并提供兼容分支。

因此本仓库**不提供一个声称可以自动完成 API23 移植的补丁**。这种补丁在上游变化后很容易产生“能编译但运行崩溃”的假成功。

实机编译环境曾使用：

```text
JDK 17
Android SDK android-34
Build Tools 34.0.0
minSdk <= 23
```

已知本机 Launcher 正常运行约 33 MiB PSS。

如果使用新的上游版本，建议先：

1. 将 `minSdk` 调整到 23
2. 编译并逐条处理 API level 报错
3. 对所有高版本 API 用 `Build.VERSION.SDK_INT` 分支保护
4. 在电视上实测 Home、焦点移动、设置弹窗、壁纸和重启流程
5. 不要仅以“APK 能安装”为兼容完成标准
