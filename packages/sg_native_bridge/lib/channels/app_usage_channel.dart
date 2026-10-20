import 'package:flutter/services.dart';
import 'package:sg_core/sg_core.dart';

/// ============================================================================
/// 📌 جسر إحصائيات الاستخدام الأصلي (Native App Usage Bridge)
/// ----------------------------------------------------------------------------
/// يستعلم من نظام أندرويد عن UsageStatsManager ومن آبل عن DeviceActivity
/// لجلب أوقات استخدام كل تطبيق بالدقائق.
/// ============================================================================

class AppUsageBridge {
  static const MethodChannel _channel = MethodChannel(AppConstants.methodChannelName);

  const AppUsageBridge._();

  /// جلب ملخص استخدام التطبيقات لليوم الحالي
  /// يعيد قائمة تحتوي على اسم التطبيق (أو المعرف) والوقت بالدقائق
  static Future<Map<String, int>> getDailyUsageStats() async {
    try {
      final Map<dynamic, dynamic>? rawStats = await _channel.invokeMethod<Map<dynamic, dynamic>>('getDailyUsageStats');
      if (rawStats == null) return {};

      return rawStats.map((key, value) => MapEntry(key.toString(), (value as num).toInt()));
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل جلب إحصائيات الاستخدام الأصلية',
        platform: e.code,
      );
    }
  }

  /// التحقق من منح صلاحية الوصول لإحصائيات الاستخدام (Usage Access)
  static Future<bool> hasUsageStatsPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasUsageStatsPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل التحقق من صلاحية إحصائيات الاستخدام',
        platform: e.code,
      );
    }
  }

  /// فتح شاشة إعدادات النظام لطلب إذن الوصول للإحصائيات
  static Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod<void>('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل فتح شاشة إعدادات إذن الاستخدام',
        platform: e.code,
      );
    }
  }
}
