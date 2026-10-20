// ============================================================================
// 📌 كيان الطفل (Child Entity)
// ----------------------------------------------------------------------------
// يمثل الطفل في طبقة منطق الأعمال المجردة (Domain)، بعيداً عن أي مكتبات خارجية.
// ============================================================================

class ChildEntity {
  /// المعرف الفريد للطفل في النظام
  final String id;

  /// معرف حساب الأب المرتبط به
  final String parentId;

  /// اسم الطفل
  final String name;

  /// عمر الطفل
  final int age;

  /// الصورة الشخصية أو الرمز التعبيري (Avatar)
  final String? avatarUrl;

  /// الحد اليومي المسموح به لوقت الشاشة بالدقائق
  final int dailyScreenTimeLimitMinutes;

  /// الوقت المستهلك اليوم بالدقائق
  final int usedScreenTimeTodayMinutes;

  /// هل الجهاز مقفل حالياً بأمر من الأب؟
  final bool isLocked;

  /// تاريخ آخر نشاط أو اتصال للجهاز
  final DateTime lastActiveAt;

  const ChildEntity({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    this.avatarUrl,
    required this.dailyScreenTimeLimitMinutes,
    required this.usedScreenTimeTodayMinutes,
    required this.isLocked,
    required this.lastActiveAt,
  });

  /// حساب الوقت المتبقي للطفل اليوم بالدقائق
  int get remainingMinutes {
    final remaining = dailyScreenTimeLimitMinutes - usedScreenTimeTodayMinutes;
    return remaining > 0 ? remaining : 0;
  }

  /// هل استنفد الطفل وقته اليومي المسموح به؟
  bool get hasExhaustedTime => remainingMinutes <= 0;
}
