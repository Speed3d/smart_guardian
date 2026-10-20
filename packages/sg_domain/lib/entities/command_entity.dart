// ============================================================================
// 📌 كيان الأوامر (Command Entity)
// ----------------------------------------------------------------------------
// يمثل الأوامر الصادرة من تطبيق الأب إلى جهاز الطفل (قفل، فك قفل، تمديد وقت، إلخ).
// ============================================================================

enum CommandStatus {
  pending,   // بانتظار الاستلام والتنفيذ
  delivered, // تم استلامه من جهاز الطفل
  executed,  // تم تنفيذه بنجاح على نظام التشغيل
  failed,    // فشل التنفيذ
}

class CommandEntity {
  /// المعرف الفريد للأمر
  final String id;

  /// معرف الطفل المستهدف
  final String childId;

  /// معرف الجهاز المستهدف
  final String deviceId;

  /// نوع الأمر (AppConstants.commandLockDevice, إلخ)
  final String action;

  /// أي بيانات إضافية للأمر (مثل عدد دقائق التمديد أو اسم حزمة التطبيق المحظور)
  final Map<String, dynamic>? payload;

  /// حالة الأمر الحالية
  final CommandStatus status;

  /// وقت إصدار الأمر
  final DateTime createdAt;

  const CommandEntity({
    required this.id,
    required this.childId,
    required this.deviceId,
    required this.action,
    this.payload,
    required this.status,
    required this.createdAt,
  });
}
