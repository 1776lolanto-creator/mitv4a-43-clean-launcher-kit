# Android 6 wallpaper storage permission

Launcher 使用 `ctx.getExternalFilesDir(null)`，本机解析到：

```text
/storage/emulated/0/Android/data/com.gathin.tvhome/files/
```

在这台 Xiaomi Android 6 ROM 上，正常 App 进程读取该目录会报：

```text
EACCES (Permission denied)
```

即使 `run-as com.gathin.tvhome cat ...` 能成功，也不能证明正常 Launcher 进程有相同 supplementary groups。

## Manifest

加入：

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 安装后授权

```bash
adb shell pm grant \
  com.gathin.tvhome \
  android.permission.READ_EXTERNAL_STORAGE
```

验证日志：

```bash
adb logcat -d | grep -E 'TvHome\.Config|config\.json|wallpaper\.jpg'
```

不应再出现 `open failed: EACCES`。
