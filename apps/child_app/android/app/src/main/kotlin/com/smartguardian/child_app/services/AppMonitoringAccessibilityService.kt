package com.smartguardian.child_app.services

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import com.smartguardian.child_app.ui.BlockOverlayActivity

/**
 * ============================================================================
 * 📌 خدمة سهولة الوصول لمراقبة التطبيقات (App Monitoring Accessibility Service)
 * ----------------------------------------------------------------------------
 * الوظائف الرئيسية:
 * 1. رصد التطبيقات النشطة في واجهة الهاتف (Foreground App) لحظياً.
 * 2. التحقق مما إذا كان التطبيق المفتوح مدرجاً ضمن قائمة التطبيقات المحظورة.
 * 3. في حال الحظر: يتم فوراً غلق التطبيق وإظهار شاشة الحظر التنبيهية (Block Overlay).
 * 4. متوافقة مع متطلبات الخصوصية وسياسات Google Play (لا تسجل النصوص ولا المفاتيح).
 * ============================================================================
 */
class AppMonitoringAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "AccessibilityService"
        private const val PREFS_NAME = "smart_guardian_app_rules"
        private const val KEY_BLOCKED_PACKAGES = "blocked_packages"

        @Volatile
        var isServiceRunning: Boolean = false
            private set

        /**
         * تحديث قائمة الحزم المحظورة وحفظها في التخزين المحلي المشترك
         */
        fun updateBlockedPackages(context: Context, packages: Set<String>) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().putStringSet(KEY_BLOCKED_PACKAGES, packages).apply()
            Log.i(TAG, "Updated blocked packages count: ${packages.size}")
        }

        /**
         * جلب قائمة الحزم المحظورة الحالية
         */
        fun getBlockedPackages(context: Context): Set<String> {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            return prefs.getStringSet(KEY_BLOCKED_PACKAGES, emptySet()) ?: emptySet()
        }

        /**
         * التحقق مما إذا كانت خدمة سهولة الوصول مفعلة في إعدادات النظام
         */
        fun isAccessibilityEnabled(context: Context): Boolean {
            val expectedServiceName = "${context.packageName}/${AppMonitoringAccessibilityService::class.java.canonicalName}"
            val enabledServices = Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            ) ?: return false

            val colonSplitter = TextUtils.SimpleStringSplitter(':')
            colonSplitter.setString(enabledServices)
            while (colonSplitter.hasNext()) {
                val componentName = colonSplitter.next()
                if (componentName.equals(expectedServiceName, ignoreCase = true)) {
                    return true
                }
            }
            return false
        }
    }

    private var launcherPackages: Set<String> = emptySet()

    override fun onServiceConnected() {
        super.onServiceConnected()
        isServiceRunning = true
        launcherPackages = getInstalledLaunchers()
        Log.i(TAG, "Smart Guardian Accessibility Service connected successfully.")
    }

    override fun onDestroy() {
        super.onDestroy()
        isServiceRunning = false
        Log.w(TAG, "Smart Guardian Accessibility Service destroyed.")
    }

    override fun onInterrupt() {
        Log.w(TAG, "Smart Guardian Accessibility Service interrupted.")
    }

    /**
     * استقبال أحداث النظام لرصد التطبيق الذي تم فتحه
     */
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        // رصد حدث تغير النافذة النشطة فقط
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return

            // تجاهل تطبيق Smart Guardian نفسه والتطبيقات الخاصة بالنظام وواجهة اللانشر
            if (packageName == applicationContext.packageName ||
                launcherPackages.contains(packageName) ||
                isSystemPackage(packageName)
            ) {
                return
            }

            // فحص هل التطبيق مدرج في قائمة الحظر
            val blockedApps = getBlockedPackages(applicationContext)
            if (blockedApps.contains(packageName)) {
                Log.w(TAG, "Blocked app detected in foreground: $packageName. Intercepting...")
                handleBlockedApp(packageName)
            }
        }
    }

    /**
     * التعامل مع التطبيق المحظور: العودة للرئيسية وإظهار شاشة الحظر
     */
    private fun handleBlockedApp(packageName: String) {
        try {
            // توجيه النظام للشاشة الرئيسية فوراً
            val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            startActivity(homeIntent)

            // إظهار شاشة الحظر المنبثقة للطفل
            val overlayIntent = Intent(applicationContext, BlockOverlayActivity::class.java).apply {
                putExtra(BlockOverlayActivity.EXTRA_BLOCKED_PACKAGE, packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            startActivity(overlayIntent)
        } catch (e: Exception) {
            Log.e(TAG, "Error handling blocked app interception", e)
        }
    }

    /**
     * جلب أسماء حزم واجهات المستخدم الرئيسية (Launchers) لتفادي حظرها
     */
    private fun getInstalledLaunchers(): Set<String> {
        val launchers = mutableSetOf<String>()
        val pm = packageManager
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
        }
        val resolveInfoList = pm.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
        for (info in resolveInfoList) {
            info.activityInfo?.packageName?.let { launchers.add(it) }
        }
        return launchers
    }

    /**
     * استبعاد حزم واجهة النظام الأساسية من الفحص
     */
    private fun isSystemPackage(packageName: String): Boolean {
        return packageName == "com.android.systemui" ||
               packageName == "com.android.settings" ||
               packageName == "android"
    }
}
