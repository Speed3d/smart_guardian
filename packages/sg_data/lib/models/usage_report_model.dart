import 'package:sg_domain/sg_domain.dart';

/// ============================================================================
/// 📌 نموذج بيانات تقرير الاستخدام (Usage Report Model / DTO)
/// ----------------------------------------------------------------------------
/// يحول كائن تقرير الاستخدام من وإلى Map متوافقة مع Cloud Firestore.
/// ============================================================================

class UsageReportModel extends DailyUsageReportEntity {
  const UsageReportModel({
    required super.id,
    required super.childId,
    required super.deviceId,
    required super.date,
    required super.appUsageMinutes,
    required super.totalScreenTimeMinutes,
    required super.updatedAt,
  });

  /// إنشاء الكائن من Map مسترجعة من Firestore
  factory UsageReportModel.fromMap(Map<String, dynamic> map, String id) {
    final rawApps = map['appUsageMinutes'] as Map<dynamic, dynamic>? ?? {};
    final convertedApps = rawApps.map(
      (k, v) => MapEntry(k.toString(), (v as num).toInt()),
    );

    return UsageReportModel(
      id: id,
      childId: map['childId'] as String? ?? '',
      deviceId: map['deviceId'] as String? ?? '',
      date: map['date'] as String? ?? '',
      appUsageMinutes: convertedApps,
      totalScreenTimeMinutes: (map['totalScreenTimeMinutes'] as num?)?.toInt() ?? 0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
    );
  }

  /// تحويل الكائن إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'deviceId': deviceId,
      'date': date,
      'appUsageMinutes': appUsageMinutes,
      'totalScreenTimeMinutes': totalScreenTimeMinutes,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
