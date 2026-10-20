package com.smartguardian.child_app.bridge

import android.app.Activity
import android.content.Intent
import android.provider.Settings
import android.util.Log
import com.smartguardian.child_app.services.AppMonitoringAccessibilityService
import com.smartguardian.child_app.services.ChildForegroundService
import com.smartguardian.child_app.utils.DeviceAdminHelper
import com.smartguardian.child_app.utils.UsageStatsHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * ============================================================================
 * 📌 معالج جسر القنوات الأصلية (Native Platform Channel Handler) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يربط بين كود Dart في Flutter ومكونات نظام أندرويد الأصلية:
 * 1. قفل وفتح الجهاز عبر مسؤول الجهاز (DeviceAdmin).
 * 2. قراءة إحصائيات الاستخدام اليومية عبر UsageStatsManager.
 * 3. إدارة قائمة التطبيقات المحظورة لخدمة سهولة الوصول (AccessibilityService).
 * 4. تشغيل وإيقاف الخدمة الدائمة (ForegroundService).
 * ============================================================================
 */
class NativeBridgeHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "NativeBridgeHandler"
        const val CHANNEL_NAME = "com.smartguardian/native_bridge"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                // --- عمليات إدارة الجهاز والقفل (Device Admin & Lock) ---
                "lockDevice" -> {
                    val success = DeviceAdminHelper.lockDevice(activity)
                    result.success(success)
                }

                "unlockDevice" -> {
                    val success = DeviceAdminHelper.unlockDevice(activity)
                    result.success(success)
                }

                "isDeviceAdminActive" -> {
                    val isActive = DeviceAdminHelper.isAdminActive(activity)
                    result.success(isActive)
                }

                "requestDeviceAdmin" -> {
                    DeviceAdminHelper.requestAdminPermission(activity)
                    result.success(true)
                }

                // --- عمليات إحصائيات الاستخدام (Usage Stats) ---
                "getDailyUsageStats" -> {
                    val stats = UsageStatsHelper.getDailyUsageStats(activity)
                    result.success(stats)
                }

                "hasUsageStatsPermission" -> {
                    val hasPerm = UsageStatsHelper.hasUsageStatsPermission(activity)
                    result.success(hasPerm)
                }

                "requestUsageStatsPermission" -> {
                    UsageStatsHelper.openUsageStatsSettings(activity)
                    result.success(true)
                }

                // --- عمليات قائمة حظر التطبيقات وسهولة الوصول (Accessibility & App Blocking) ---
                "setBlockedPackages" -> {
                    val packageList = call.argument<List<String>>("packages") ?: emptyList()
                    AppMonitoringAccessibilityService.updateBlockedPackages(
                        activity,
                        packageList.toSet()
                    )
                    result.success(true)
                }

                "getBlockedPackages" -> {
                    val blockedSet = AppMonitoringAccessibilityService.getBlockedPackages(activity)
                    result.success(blockedSet.toList())
                }

                "isAccessibilityServiceEnabled" -> {
                    val isEnabled = AppMonitoringAccessibilityService.isAccessibilityEnabled(activity)
                    result.success(isEnabled)
                }

                "requestAccessibilityPermission" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    activity.startActivity(intent)
                    result.success(true)
                }

                // --- عمليات الخدمة الدائمة (Foreground Service) ---
                "startForegroundService" -> {
                    ChildForegroundService.startService(activity)
                    result.success(true)
                }

                "stopForegroundService" -> {
                    ChildForegroundService.stopService(activity)
                    result.success(true)
                }

                "isForegroundServiceRunning" -> {
                    result.success(ChildForegroundService.isServiceRunning)
                }

                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling method call: ${call.method}", e)
            result.error("NATIVE_BRIDGE_ERROR", e.localizedMessage, e.stackTraceToString())
        }
    }
}
