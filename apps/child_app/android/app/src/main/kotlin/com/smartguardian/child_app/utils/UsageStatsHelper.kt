package com.smartguardian.child_app.utils

import android.app.Activity
import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import android.util.Log
import java.util.Calendar

/**
 * ============================================================================
 * 📌 مساعد إحصائيات الاستخدام (Usage Stats Helper) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يستعلم عن وقت الشاشة لكل تطبيق مثبت على جهاز الطفل عبر UsageStatsManager.
 * ويتحقق من منح إذن الوصول إلى بيانات الاستخدام (PACKAGE_USAGE_STATS).
 * ============================================================================
 */
object UsageStatsHelper {

    private const val TAG = "UsageStatsHelper"
    const val REQUEST_CODE_USAGE_STATS = 2002

    /**
     * التحقق من منح صلاحية الوصول لبيانات الاستخدام (Usage Access Permission)
     */
    fun hasUsageStatsPermission(context: Context): Boolean {
        return try {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as? AppOpsManager
                ?: return false

            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    context.packageName
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    context.packageName
                )
            }
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            Log.e(TAG, "Error checking usage stats permission", e)
            false
        }
    }

    /**
     * فتح صفحة إعدادات النظام المخصصة لمنح إذن الوصول لبيانات الاستخدام
     */
    fun openUsageStatsSettings(activity: Activity) {
        try {
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    data = Uri.fromParts("package", activity.packageName, null)
                }
            }
            activity.startActivity(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Error opening usage stats settings with package URI, falling back to general settings", e)
            try {
                activity.startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
            } catch (fallbackException: Exception) {
                Log.e(TAG, "Failed to open usage access settings", fallbackException)
            }
        }
    }

    /**
     * جلب إحصائيات استخدام التطبيقات اليومية (منذ بداية اليوم الحالي وحتى اللحظة)
     * تعيد خريطة (Map) تحتوي على:
     * - المفتاح (Key): اسم حزمة التطبيق (Package Name مثل com.google.android.youtube)
     * - القيمة (Value): إجمالي وقت الاستخدام بالدقائق (Total Minutes)
     */
    fun getDailyUsageStats(context: Context): Map<String, Int> {
        val resultMap = mutableMapOf<String, Int>()

        if (!hasUsageStatsPermission(context)) {
            Log.w(TAG, "Cannot get daily usage stats: Permission not granted.")
            return resultMap
        }

        try {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
                ?: return resultMap

            // حساب وقت بداية اليوم الحالي (Midnight 00:00:00)
            val calendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            val startOfDay = calendar.timeInMillis
            val currentTime = System.currentTimeMillis()

            // الاستعلام عن إحصائيات التطبيقات لليوم
            val statsList: List<UsageStats>? = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startOfDay,
                currentTime
            )

            if (!statsList.isNullOrEmpty()) {
                for (usageStat in statsList) {
                    val foregroundTimeMs = usageStat.totalTimeInForeground
                    // تصفية التطبيقات التي تم فتحها دقيقة واحدة على الأقل
                    if (foregroundTimeMs > 0) {
                        val minutes = (foregroundTimeMs / (1000 * 60)).toInt()
                        val pkgName = usageStat.packageName

                        // تجميع الوقت إذا تكررت السجلات
                        val existing = resultMap[pkgName] ?: 0
                        resultMap[pkgName] = existing + minutes
                    }
                }
            }
            Log.i(TAG, "Queried ${resultMap.size} apps with daily usage stats.")
        } catch (e: Exception) {
            Log.e(TAG, "Error fetching daily usage stats from UsageStatsManager", e)
        }

        return resultMap
    }
}
