import 'dart:async';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';

/// ============================================================================
/// 📌 مزامن الاستخدام المجمع (Batch Usage Syncer) - Smart Guardian
/// ----------------------------------------------------------------------------
/// يجمع إحصائيات استخدام التطبيقات اليومية من Android UsageStatsManager
/// ويرفعها مجمعة إلى Cloud Firestore على فترات متباعدة (كل 30-60 دقيقة).
/// هذا التصميم الذكي يضمن:
/// 1. عدم استنزاف بطارية جهاز الطفل.
/// 2. بقاء المشروع ضمن الفئة المجانية أو بأقل تكلفة ممكنة على Firebase.
/// ============================================================================

class BatchUsageSyncer {
  final SyncDailyUsageUseCase syncDailyUsageUseCase;
  Timer? _periodicTimer;

  BatchUsageSyncer({
    required this.syncDailyUsageUseCase,
  });

  /// تنفيذ المزامنة الفورية الآن
  Future<bool> syncNow({
    required String childId,
    required String deviceId,
  }) async {
    try {
      final hasPermission = await AppUsageBridge.hasUsageStatsPermission();
      if (!hasPermission) return false;

      final stats = await AppUsageBridge.getDailyUsageStats();
      if (stats.isEmpty) return false;

      final now = DateTime.now();
      final dateKey = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';

      await syncDailyUsageUseCase.execute(
        childId: childId,
        deviceId: deviceId,
        date: dateKey,
        appUsageMinutes: stats,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  /// بدء المزامنة الدورية المجدولة
  void startPeriodicSync({
    required String childId,
    required String deviceId,
    Duration interval = const Duration(minutes: 60),
  }) {
    _periodicTimer?.cancel();
    // تنفيذ مزامنة أولى مباشرة
    syncNow(childId: childId, deviceId: deviceId);

    // تكرار المزامنة كل فاصل زمني محدد
    _periodicTimer = Timer.periodic(interval, (_) {
      syncNow(childId: childId, deviceId: deviceId);
    });
  }

  /// إيقاف المزامنة الدورية
  void stop() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';
}
