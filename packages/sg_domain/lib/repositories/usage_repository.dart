import '../entities/usage_report_entity.dart';

/// ============================================================================
/// 📌 واجهة مستودع استخدام التطبيقات (Usage Repository Interface)
/// ----------------------------------------------------------------------------
/// عقد تجريدي لحفظ واسترجاع تقارير وقت الشاشة المجمعة لتقليل تكلفة القراءات والكتابات.
/// ============================================================================

abstract class UsageRepository {
  /// حفظ أو تحديث تقرير الاستخدام اليومي المجمع
  Future<void> saveDailyUsageReport(DailyUsageReportEntity report);

  /// جلب تقرير استخدام اليوم لطفل معين في تاريخ محدد
  Future<DailyUsageReportEntity?> getDailyUsageReport(
      String childId, String date);

  /// الاستماع المباشر لتقرير الاستخدام اليومي لطفل معين
  Stream<DailyUsageReportEntity?> listenDailyUsageReport(
      String childId, String date);
}
