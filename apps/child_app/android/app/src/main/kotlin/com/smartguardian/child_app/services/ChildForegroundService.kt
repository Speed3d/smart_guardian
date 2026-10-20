package com.smartguardian.child_app.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import com.smartguardian.child_app.MainActivity
import com.smartguardian.child_app.R

/**
 * ============================================================================
 * 📌 الخدمة الدائمة في الخلفية (Child Foreground Service) - Smart Guardian
 * ----------------------------------------------------------------------------
 * الوظائف الرئيسية:
 * 1. الحفاظ على تشغيل التطبيق في الخلفية 24/7 ومنع نظام أندرويد من إغلاقه (Keep-Alive).
 * 2. إظهار إشعار دائم وشفاف يوضح أن نظام الحماية الأبوية نشط.
 * 3. العمل بالتوافق مع Android 8.0+ و Android 14+ مع نوع الخدمة المناسب.
 * ============================================================================
 */
class ChildForegroundService : Service() {

    companion object {
        private const val TAG = "ChildForegroundService"
        private const val NOTIFICATION_ID = 10001
        private const val CHANNEL_ID = "smart_guardian_protection_channel"

        const val ACTION_START_SERVICE = "ACTION_START_FOREGROUND_PROTECTION"
        const val ACTION_STOP_SERVICE = "ACTION_STOP_FOREGROUND_PROTECTION"

        @Volatile
        var isServiceRunning: Boolean = false
            private set

        /**
         * بدء تشغيل الخدمة الدائمة
         */
        fun startService(context: Context) {
            val intent = Intent(context, ChildForegroundService::class.java).apply {
                action = ACTION_START_SERVICE
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        /**
         * إيقاف تشغيل الخدمة الدائمة
         */
        fun stopService(context: Context) {
            val intent = Intent(context, ChildForegroundService::class.java).apply {
                action = ACTION_STOP_SERVICE
            }
            context.stopService(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_SERVICE) {
            Log.i(TAG, "Stopping Child Foreground Service via Intent Action")
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            isServiceRunning = false
            return START_NOT_STICKY
        }

        Log.i(TAG, "Starting Child Foreground Service...")
        val notification = buildForegroundNotification()
        startForeground(NOTIFICATION_ID, notification)
        isServiceRunning = true

        // إرجاع START_STICKY يضمن قيام النظام بإعادة تشغيل الخدمة تلقائياً في حال إغلاقها
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        isServiceRunning = false
        Log.w(TAG, "Child Foreground Service destroyed.")
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null // ليست خدمة مرتبطة (Unbound Service)
    }

    /**
     * إنشاء قناة الإشعارات الخاصة بالخدمة (مطلوبة في Android 8.0+)
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelName = getString(R.string.foreground_service_channel_name)
            val channelDesc = getString(R.string.foreground_service_channel_desc)
            val importance = NotificationManager.IMPORTANCE_LOW // صوت صامت لعدم إزعاج المستخدم

            val channel = NotificationChannel(CHANNEL_ID, channelName, importance).apply {
                description = channelDesc
                setShowBadge(false)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
            notificationManager?.createNotificationChannel(channel)
        }
    }

    /**
     * بناء الإشعار الدائم غير القابل للمسح
     */
    private fun buildForegroundNotification(): Notification {
        val launchIntent = Intent(this, MainActivity::class.java)
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(this, 0, launchIntent, flags)

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        return builder
            .setContentTitle(getString(R.string.foreground_service_title))
            .setContentText(getString(R.string.foreground_service_text))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setAutoCancel(false)
            .build()
    }
}
