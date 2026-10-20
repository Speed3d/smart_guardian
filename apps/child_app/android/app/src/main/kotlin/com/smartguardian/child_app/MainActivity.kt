package com.smartguardian.child_app

import androidx.annotation.NonNull
import com.smartguardian.child_app.bridge.NativeBridgeHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * ============================================================================
 * 📌 النشاط الرئيسي لتطبيق الطفل (Child App MainActivity) - Smart Guardian
 * ----------------------------------------------------------------------------
 * يربط محرك Flutter بمكونات أندرويد الأصلية من خلال NativeBridgeHandler
 * لتمكين وظائف القفل، ومراقبة وقت الشاشة، وحظر التطبيقات عبر سهولة الوصول.
 * ============================================================================
 */
class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // تسجيل معالج القناة الأصلية MethodChannel للتحكم وإحصائيات الاستخدام
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            NativeBridgeHandler.CHANNEL_NAME
        )
        channel.setMethodCallHandler(NativeBridgeHandler(this))
    }
}
