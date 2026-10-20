import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 كيان جهاز الطفل (Device Entity)
// ----------------------------------------------------------------------------
// يمثل بيانات الهاتف الذكي الخاص بالطفل بعد نجاح عملية الاقتران بالكود.
// ============================================================================

class DeviceEntity extends Equatable {
  /// المعرف الفريد للجهاز
  final String id;

  /// معرف الطفل المرتبط بهذا الجهاز
  final String childId;

  /// معرف حساب الأب
  final String parentId;

  /// طراز ونوع الجهاز (مثال: Samsung Galaxy A54 أو iPhone 13)
  final String model;

  /// نظام التشغيل والإصدار (مثال: Android 14 أو iOS 17.2)
  final String osVersion;

  /// هل الجهاز مقترن ونشط حالياً؟
  final bool isPaired;

  /// مستوى شحن البطارية الحالي (نسبة مئوية من 0 إلى 100)
  final int batteryLevel;

  /// وقت آخر اتصال أو نشاط للجهاز
  final DateTime lastSeenAt;

  const DeviceEntity({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.model,
    required this.osVersion,
    this.isPaired = true,
    this.batteryLevel = 100,
    required this.lastSeenAt,
  });

  @override
  List<Object?> get props => [
        id,
        childId,
        parentId,
        model,
        osVersion,
        isPaired,
        batteryLevel,
        lastSeenAt,
      ];
}
