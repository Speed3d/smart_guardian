import '../entities/usage_report_entity.dart';
import '../repositories/usage_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام مزامنة وقت الاستخدام اليومي (Sync Daily Usage Use Case)
/// ----------------------------------------------------------------------------
/// تجمع أوقات استخدام التطبيقات وتحسب إجمالي وقت الشاشة وترفع تقريراً
/// موحداً لليوم الحالي لتقليل كلفة الاستعلامات في قاعدة البيانات.
/// ============================================================================

class SyncDailyUsageUseCase {
  final UsageRepository _repository;

  const SyncDailyUsageUseCase(this._repository);

  Future<void> execute({
    required String childId,
    required String deviceId,
    required String date,
    required Map<String, int> appUsageMinutes,
  }) async {
    // حساب إجمالي الدقائق المستهلكة من كافة التطبيقات
    final totalMinutes = appUsageMinutes.values.fold<int>(
      0,
      (previousValue, element) => previousValue + element,
    );

    final report = DailyUsageReportEntity(
      id: '${childId}_$date',
      childId: childId,
      deviceId: deviceId,
      date: date,
      appUsageMinutes: appUsageMinutes,
      totalScreenTimeMinutes: totalMinutes,
      updatedAt: DateTime.now(),
    );

    await _repository.saveDailyUsageReport(report);
  }
}
