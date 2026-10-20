package com.smartguardian.child_app.utils

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import com.smartguardian.child_app.R
import com.smartguardian.child_app.receivers.SmartGuardianDeviceAdminReceiver

/**
 * ============================================================================
 * 📌 مساعد إدارة الجهاز (Device Admin Helper) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يسهل التعامل مع DevicePolicyManager لقفل الشاشة والتحقق من الصلاحيات الإدارية.
 * ============================================================================
 */
object DeviceAdminHelper {

    private const val TAG = "DeviceAdminHelper"
    const val REQUEST_CODE_DEVICE_ADMIN = 2001

    /**
     * جلب المعرف المكوّن (ComponentName) لمستقبل الإدارة
     */
    fun getComponentName(context: Context): ComponentName {
        return ComponentName(context, SmartGuardianDeviceAdminReceiver::class.java)
    }

    /**
     * التحقق مما إذا كانت صلاحية مسؤول الجهاز مفعلة حالياً
     */
    fun isAdminActive(context: Context): Boolean {
        return try {
            val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as? DevicePolicyManager
            dpm?.isAdminActive(getComponentName(context)) ?: false
        } catch (e: Exception) {
            Log.e(TAG, "Error checking if device admin is active", e)
            false
        }
    }

    /**
     * فتح شاشة طلب صلاحية مسؤول الجهاز للمستخدم
     */
    fun requestAdminPermission(activity: Activity, requestCode: Int = REQUEST_CODE_DEVICE_ADMIN) {
        try {
            val component = getComponentName(activity)
            val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
                putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, component)
                putExtra(
                    DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                    activity.getString(R.string.device_admin_description)
                )
            }
            activity.startActivityForResult(intent, requestCode)
        } catch (e: Exception) {
            Log.e(TAG, "Error launching device admin request intent", e)
        }
    }

    /**
     * قفل شاشة الهاتف فوراً (Lock Device Now)
     * يتطلب أن تكون صلاحية مسؤول الجهاز ممنوحة مسبقاً
     */
    fun lockDevice(context: Context): Boolean {
        return try {
            val dpm = context.getSystemService(Context.DEVICE_POLICY_SERVICE) as? DevicePolicyManager
            if (dpm != null && dpm.isAdminActive(getComponentName(context))) {
                dpm.lockNow()
                Log.i(TAG, "Device successfully locked by Smart Guardian.")
                true
            } else {
                Log.w(TAG, "Cannot lock device: Device Admin permission is not active!")
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Exception while attempting to lock device", e)
            false
        }
    }

    /**
     * تنشيط وإيقاظ شاشة الهاتف (Wake Screen)
     * ملاحظة: إلغاء القفل الكامل المحمي بكلمة سر يتطلب إدخال الطفل لرمزه الشخصي بحسب أمان أندرويد
     */
    @Suppress("DEPRECATION")
    fun unlockDevice(context: Context): Boolean {
        return try {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
            if (powerManager != null) {
                val wakeLock = powerManager.newWakeLock(
                    PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                    "SmartGuardian:UnlockWakeLock"
                )
                wakeLock.acquire(3000) // إيقاظ الشاشة لمدة 3 ثوانٍ
                wakeLock.release()
                Log.i(TAG, "Device screen awakened successfully.")
                true
            } else {
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Exception while attempting to wake screen", e)
            false
        }
    }
}
