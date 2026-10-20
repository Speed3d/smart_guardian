// ============================================================================
// 📌 كيان تقرير الاستخدام المجمع (Daily Usage Report Entity)
// ----------------------------------------------------------------------------
// يمثل تقريراً مجمعاً لوقت الشاشة اليومي لكل تطبيق، يُرفع بشكل دوري أو مجمع
// لتجنب تكرار عمليات الكتابة في Cloud Firestore وتقليل التكلفة المالية للمشروع.
// ============================================================================

class DailyUsageReportEntity {
  /// المعرف الفريد للتقرير (عادةً childId_date)
  final String id;

  /// معرف الطفل
  final String childId;

  /// معرف الجهاز
  final String deviceId;

  /// تاريخ اليوم بصيغة (YYYY-MM-DD)
  final String date;

  /// خريطة تحتوي على اسم حزمة التطبيق ووقت الاستخدام بالدقائق
  final Map<String, int> appUsageMinutes;

  /// إجمالي وقت الشاشة بالدقائق لهذا اليوم
  final int totalScreenTimeMinutes;

  /// تاريخ ووقت آخر مزامنة
  final DateTime updatedAt;

  const DailyUsageReportEntity({
    required this.id,
    required this.childId,
    required this.deviceId,
    required this.date,
    required this.appUsageMinutes,
    required this.totalScreenTimeMinutes,
    required this.updatedAt,
  });

  DailyUsageReportEntity copyWith({
    String? id,
    String? childId,
    String? deviceId,
    String? date,
    Map<String, int>? appUsageMinutes,
    int? totalScreenTimeMinutes,
    DateTime? updatedAt,
  }) {
    return DailyUsageReportEntity(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      deviceId: deviceId ?? this.deviceId,
      date: date ?? this.date,
      appUsageMinutes: appUsageMinutes ?? this.appUsageMinutes,
      totalScreenTimeMinutes:
          totalScreenTimeMinutes ?? this.totalScreenTimeMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
