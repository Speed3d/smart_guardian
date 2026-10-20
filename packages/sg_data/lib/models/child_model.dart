import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 نموذج بيانات الطفل (Child Model / DTO)
// ----------------------------------------------------------------------------
// يحول وثيقة الطفل من Cloud Firestore إلى كيان ChildEntity.
// ============================================================================

class ChildModel extends ChildEntity {
  const ChildModel({
    required super.id,
    required super.parentId,
    required super.name,
    required super.age,
    super.avatarUrl,
    required super.dailyScreenTimeLimitMinutes,
    required super.usedScreenTimeTodayMinutes,
    required super.isLocked,
    required super.lastActiveAt,
  });

  /// إنشاء كائن من خريطة Firestore
  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      parentId: map['parentId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      age: (map['age'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatarUrl'] as String?,
      dailyScreenTimeLimitMinutes:
          (map['dailyScreenTimeLimitMinutes'] as num?)?.toInt() ?? 120,
      usedScreenTimeTodayMinutes:
          (map['usedScreenTimeTodayMinutes'] as num?)?.toInt() ?? 0,
      isLocked: map['isLocked'] as bool? ?? false,
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastActiveAt'] as int)
          : DateTime.now(),
    );
  }

  /// تحويل الكائن إلى خريطة Firestore
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'name': name,
      'age': age,
      'avatarUrl': avatarUrl,
      'dailyScreenTimeLimitMinutes': dailyScreenTimeLimitMinutes,
      'usedScreenTimeTodayMinutes': usedScreenTimeTodayMinutes,
      'isLocked': isLocked,
      'lastActiveAt': lastActiveAt.millisecondsSinceEpoch,
    };
  }
}
