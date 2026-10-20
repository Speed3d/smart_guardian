package com.smartguardian.child_app.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.smartguardian.child_app.services.ChildForegroundService

/**
 * ============================================================================
 * 📌 مستقبل إعادة تشغيل الجهاز (Boot Receiver) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يستمع لأحداث إقلاع الهاتف:
 * 1. Intent.ACTION_BOOT_COMPLETED
 * 2. Intent.ACTION_MY_PACKAGE_REPLACED (تحديث التطبيق)
 * ليعيد تشغيل الخدمة الدائمة (ChildForegroundService) فوراً وبشكل تلقائي.
 * ============================================================================
 */
class BootReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.i(TAG, "Received broadcast intent: $action")

        if (action == Intent.ACTION_BOOT_COMPLETED || action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            Log.i(TAG, "Re-launching ChildForegroundService after device restart or update...")
            try {
                ChildForegroundService.startService(context)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start ChildForegroundService on boot", e)
            }
        }
    }
}
