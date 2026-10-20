import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_usage_datasource.dart';
import '../models/usage_report_model.dart';

// ============================================================================
// 📌 تطبيق مستودع تقارير الاستخدام (Usage Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة UsageRepository بمصدر بيانات Firestore.
// ============================================================================

class UsageRepositoryImpl implements UsageRepository {
  final FirestoreUsageDataSource _dataSource;

  UsageRepositoryImpl(this._dataSource);

  @override
  Future<void> saveDailyUsageReport(DailyUsageReportEntity report) {
    final model = UsageReportModel(
      id: report.id,
      childId: report.childId,
      deviceId: report.deviceId,
      date: report.date,
      appUsageMinutes: report.appUsageMinutes,
      totalScreenTimeMinutes: report.totalScreenTimeMinutes,
      updatedAt: report.updatedAt,
    );
    return _dataSource.saveUsageReport(model);
  }

  @override
  Future<DailyUsageReportEntity?> getDailyUsageReport(
      String childId, String date) {
    return _dataSource.getUsageReport(childId, date);
  }

  @override
  Stream<DailyUsageReportEntity?> listenDailyUsageReport(
      String childId, String date) {
    return _dataSource.listenUsageReport(childId, date);
  }
}
