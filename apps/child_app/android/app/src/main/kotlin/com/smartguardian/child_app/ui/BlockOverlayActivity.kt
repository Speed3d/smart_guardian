package com.smartguardian.child_app.ui

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import com.smartguardian.child_app.R

/**
 * ============================================================================
 * 📌 شاشة حظر التطبيقات المنبثقة (Block Overlay Activity) - Smart Guardian
 * ----------------------------------------------------------------------------
 * تفتح فوراً عند محاولة الطفل فتح أي تطبيق تم حظره عبر لوحة الأب.
 * تمنع الرجوع للتطبيق المحظور وتوفر زراً واحداً فقط للعودة للشاشة الرئيسية.
 * ============================================================================
 */
class BlockOverlayActivity : Activity() {

    companion object {
        const val EXTRA_BLOCKED_PACKAGE = "extra_blocked_package"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_block_overlay)

        val blockedPackage = intent.getStringExtra(EXTRA_BLOCKED_PACKAGE) ?: ""
        val tvPackageName = findViewById<TextView>(R.id.tvPackageName)
        val btnGoHome = findViewById<Button>(R.id.btnGoHome)

        // محاولة عرض الاسم الظاهر للتطبيق بدلاً من اسم الحزمة إن أمكن
        val appLabel = getAppLabel(blockedPackage)
        if (appLabel.isNotBlank()) {
            tvPackageName.text = "التطبيق المقيد: $appLabel"
        } else {
            tvPackageName.text = blockedPackage
        }

        // عند الضغط على زر العودة، يتم التوجيه إلى الشاشة الرئيسية للهاتف
        btnGoHome.setOnClickListener {
            navigateToHomeScreen()
        }
    }

    /**
     * منع الرجوع للخلف حتى لا يعود الطفل إلى التطبيق المحظور
     */
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        navigateToHomeScreen()
    }

    /**
     * الانتقال المباشر إلى الشاشة الرئيسية لجهاز الطفل
     */
    private fun navigateToHomeScreen() {
        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        startActivity(homeIntent)
        finish()
    }

    /**
     * استخراج اسم التطبيق المفهوم للمستخدم
     */
    private fun getAppLabel(packageName: String): String {
        return try {
            val pm = packageManager
            val appInfo = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(appInfo).toString()
        } catch (e: PackageManager.NameNotFoundException) {
            packageName
        }
    }
}
