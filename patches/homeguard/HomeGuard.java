package com.gathin.tvhome;

import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.os.SystemClock;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;

import java.util.LinkedHashSet;

/**
 * Xiaomi Android 6 can keep HomeKeyService in secure settings while the
 * AccessibilityService is no longer actually bound after an update,
 * force-stop, or reboot. This guard re-writes only our own service entry
 * while preserving every other accessibility service.
 *
 * Requires android.permission.WRITE_SECURE_SETTINGS to be declared and
 * granted once over ADB on the tested MiTV4A 43 firmware.
 */
final class HomeGuard {
    private static final String TAG = "TvHome.HomeGuard";
    private static boolean repairedThisProcess = false;

    private HomeGuard() {}

    static synchronized void repairOnce(Context context) {
        if (repairedThisProcess) return;
        repairedThisProcess = true;
        repair(context.getApplicationContext());
    }

    private static void repair(Context context) {
        try {
            ContentResolver cr = context.getContentResolver();
            ComponentName target = new ComponentName(context, HomeKeyService.class);

            String current = Settings.Secure.getString(
                    cr,
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            );

            LinkedHashSet<String> others = new LinkedHashSet<>();
            boolean found = false;

            if (!TextUtils.isEmpty(current)) {
                String[] parts = current.split(":");
                for (String part : parts) {
                    if (TextUtils.isEmpty(part)) continue;
                    ComponentName component = ComponentName.unflattenFromString(part);
                    if (target.equals(component)) {
                        found = true;
                    } else {
                        others.add(part);
                    }
                }
            }

            // Re-toggle our service if it was already listed. This handles the
            // Xiaomi state where the setting survives but the service is unbound.
            if (found) {
                Settings.Secure.putString(
                        cr,
                        Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
                        TextUtils.join(":", others)
                );
                SystemClock.sleep(120);
            }

            others.add(target.flattenToShortString());
            String repaired = TextUtils.join(":", others);

            boolean listOk = Settings.Secure.putString(
                    cr,
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
                    repaired
            );
            boolean enabledOk = Settings.Secure.putInt(
                    cr,
                    Settings.Secure.ACCESSIBILITY_ENABLED,
                    1
            );

            Log.i(TAG, "Home accessibility repaired"
                    + " list=" + listOk
                    + " enabled=" + enabledOk
                    + " wasPresent=" + found);
        } catch (Throwable t) {
            // Recovery code must never take down the launcher.
            Log.e(TAG, "Unable to repair Home accessibility", t);
        }
    }
}
