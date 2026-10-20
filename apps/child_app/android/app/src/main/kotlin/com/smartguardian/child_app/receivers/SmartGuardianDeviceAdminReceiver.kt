package com.smartguardian.child_app.receivers

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.smartguardian.child_app.R

/**
 * ============================================================================
 * 📌 مستقبل إدارة الجهاز (Device Admin Receiver) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يمنح التطبيق صلاحيات إدارية على مستوى نظام أندرويد لتنفيذ الأوامر التالية:
 * 1. قفل شاشة الجهاز فوراً (Lock Device) استجابة لأوامر ولي الأمر.
 * 2. الحماية ضد إلغاء التثبيت غير المصرح به من قبل الطفل.
 * 3. إظهار رسالة تحذيرية في حال محاولة تعطيل صلاحية الإدارة.
 * ============================================================================
 */
class SmartGuardianDeviceAdminReceiver : DeviceAdminReceiver() {

    companion object {
        private const val TAG = "DeviceAdminReceiver"
        const val PREFS_NAME = "smart_guardian_admin_prefs"
        const val KEY_IS_ADMIN_ACTIVE = "is_admin_active"
    }

    /**
     * يتم استدعاؤها فور تفعيل صلاحية مسؤول الجهاز من إعدادات النظام
     */
    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Log.i(TAG, "Smart Guardian Device Admin has been enabled.")
        
        // حفظ حالة تفعيل الصلاحية محلياً
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putBoolean(KEY_IS_ADMIN_ACTIVE, true).apply()

        Toast.makeText(
            context,
            "تم تفعيل صلاحية إدارة الجهاز بنجاح لتطبيق Smart Guardian",
            Toast.LENGTH_SHORT
        ).show()
    }

    /**
     * يتم استدعاؤها عند تعطيل صلاحية مسؤول الجهاز
     */
    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Log.w(TAG, "Smart Guardian Device Admin has been disabled!")

        // تحديث حالة الصلاحية إلى غير مفعلة
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putBoolean(KEY_IS_ADMIN_ACTIVE, false).apply()
    }

    /**
     * يتم استدعاؤها عندما يحاول المستخدم إلغاء صلاحية مسؤول الجهاز من الإعدادات
     * يعيد نصاً تحذيرياً يظهر للمستخدم قبل إتمام الإلغاء
     */
    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        Log.w(TAG, "Device Admin disable requested by user.")
        return context.getString(R.string.device_admin_disable_warning)
    }

    /**
     * رصد المحاولات الخاطئة لإدخال رمز القفل
     */
    override fun onPasswordFailed(context: Context, intent: Intent) {
        super.onPasswordFailed(context, intent)
        Log.d(TAG, "Failed device unlock attempt detected.")
    }

    /**
     * رصد نجاح فتح قفل الجهاز
     */
    override fun onPasswordSucceeded(context: Context, intent: Intent) {
        super.onPasswordSucceeded(context, intent)
        Log.d(TAG, "Successful device unlock detected.")
    }
}
