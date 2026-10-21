package com.gathin.tvhome;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

/** Re-runs HomeGuard after boot and package replacement. */
public final class HomeGuardReceiver extends BroadcastReceiver {
    private static final String TAG = "TvHome.HomeGuard";

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent != null ? intent.getAction() : "null";
        Log.i(TAG, "Receiver: " + action);
        HomeGuard.repairOnce(context);
    }
}
