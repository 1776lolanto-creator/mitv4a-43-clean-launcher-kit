# Home takeover patch for MiTV4A 43 / matrix

这台 ROM 不允许普通第三方 Launcher 通过标准 HOME chooser 接管桌面，因此使用 `HomeKeyService`。

## 1. 同时处理 HOME 和 ALL_APPS

将只处理 `KEYCODE_ALL_APPS` 的判断改成：

```java
if (event.getKeyCode() != KeyEvent.KEYCODE_ALL_APPS
        && event.getKeyCode() != KeyEvent.KEYCODE_HOME) return false;
```

在 key-up 时显式启动自己的 HOME：

```java
Intent home = new Intent(Intent.ACTION_MAIN)
        .addCategory(Intent.CATEGORY_HOME)
        .setPackage(getPackageName())
        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
startActivity(home);
```

## 2. 原厂桌面出现时拉回

```java
@Override
public void onAccessibilityEvent(AccessibilityEvent event) {
    CharSequence pkg = event.getPackageName();
    if (pkg != null && "com.mitv.tvhome".contentEquals(pkg)) {
        Intent home = new Intent(Intent.ACTION_MAIN)
                .addCategory(Intent.CATEGORY_HOME)
                .setPackage(getPackageName())
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                        | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
        startActivity(home);
    }
}
```

## 3. 开机广告时间窗回抢

在 `onServiceConnected()` 原有初始化之后加入：

```java
if (android.os.SystemClock.elapsedRealtime() < 180000) {
    final android.os.Handler handler = new android.os.Handler();

    final Runnable bringHome = new Runnable() {
        @Override
        public void run() {
            Intent home = new Intent(Intent.ACTION_MAIN)
                    .addCategory(Intent.CATEGORY_HOME)
                    .setPackage(getPackageName())
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                            | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
            startActivity(home);
        }
    };

    handler.postDelayed(bringHome, 500);
    handler.postDelayed(bringHome, 8000);
    handler.postDelayed(bringHome, 15000);
    handler.postDelayed(bringHome, 25000);
    handler.postDelayed(bringHome, 35000);
    handler.postDelayed(bringHome, 45000);
}
```

这些时间点来自本机日志。其它 ROM 应先抓启动时序再调整。

## 4. Accessibility 配置与 v1.1.0 HomeGuard

首次安装时仍需确保：

```text
com.gathin.tvhome/.HomeKeyService
```

存在于 `enabled_accessibility_services`。可以使用：

```bash
./scripts/restore-accessibility.sh
```

但 v1.1.0 不再把人工恢复作为长期方案。请继续应用 [`HOME_GUARD.md`](HOME_GUARD.md)，让 Launcher 在启动、重启和 APK 覆盖升级后自行修复 HomeKeyService。
