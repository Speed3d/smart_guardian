import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sg_core/sg_core.dart';
import '../../models/usage_report_model.dart';

// ============================================================================
// 📌 مصدر بيانات تقارير الاستخدام من Firestore (Firestore Usage DataSource)
// ----------------------------------------------------------------------------
// يدير حفظ ومزامنة تقارير وقت الشاشة المجمعة لتقليل تكلفة الاستعلامات.
// ============================================================================

abstract class FirestoreUsageDataSource {
  Future<void> saveUsageReport(UsageReportModel report);
  Future<UsageReportModel?> getUsageReport(String childId, String date);
  Stream<UsageReportModel?> listenUsageReport(String childId, String date);
}

class FirestoreUsageDataSourceImpl implements FirestoreUsageDataSource {
  final FirebaseFirestore _firestore;

  FirestoreUsageDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usageCollection =>
      _firestore.collection(AppConstants.usageLogsCollection);

  @override
  Future<void> saveUsageReport(UsageReportModel report) async {
    try {
      await _usageCollection.doc(report.id).set(report.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UsageReportModel?> getUsageReport(String childId, String date) async {
    try {
      final docId = '${childId}_$date';
      final doc = await _usageCollection.doc(docId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UsageReportModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UsageReportModel?> listenUsageReport(String childId, String date) {
    final docId = '${childId}_$date';
    return _usageCollection.doc(docId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UsageReportModel.fromMap(doc.data()!, doc.id);
    });
  }
}
