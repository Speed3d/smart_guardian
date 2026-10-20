import '../entities/child_entity.dart';

// ============================================================================
// 📌 واجهة مستودع الأطفال (Child Repository Interface)
// ----------------------------------------------------------------------------
// عقد تجريدي لإدارة بيانات الأطفال وإعدادات وقت الشاشة.
// ============================================================================

abstract class ChildRepository {
  /// جلب قائمة أطفال ولي الأمر الحالي
  Stream<List<ChildEntity>> getChildrenStream(String parentId);

  /// إضافة طفل جديد إلى العائلة
  Future<ChildEntity> addChild({
    required String parentId,
    required String name,
    required int age,
    required int dailyScreenTimeLimitMinutes,
    String? avatarUrl,
  });

  /// جلب بيانات طفل محدد بالمعرف
  Future<ChildEntity?> getChildById(String childId);

  /// تحديث حالة القفل للطفل
  Future<void> updateChildLockStatus(String childId, bool isLocked);

  /// تحديث حد وقت الشاشة اليومي بالدقائق
  Future<void> updateDailyScreenTimeLimit(String childId, int limitMinutes);

  /// تمديد وقت الشاشة المسموح لليوم
  Future<void> extendScreenTime(String childId, int additionalMinutes);
}
