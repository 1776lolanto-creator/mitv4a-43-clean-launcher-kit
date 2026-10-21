# Contributing

这个仓库是“具体型号、具体 ROM、实机证据优先”的项目。

提交新的包名、时序或系统行为时，请至少附上：

1. `ro.product.model`
2. `ro.product.device`
3. Android/API 版本
4. `ro.build.display.id`
5. 对应的 ADB 命令和原始输出
6. 是否在重启后复测

不要根据中文 App 名称猜包名。优先通过前台 Activity 确认：

```bash
./scripts/identify-foreground.sh
```

涉及删除或禁用系统组件的 PR 必须说明恢复路径。
