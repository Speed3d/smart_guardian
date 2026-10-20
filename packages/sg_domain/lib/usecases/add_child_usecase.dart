import '../entities/child_entity.dart';
import '../repositories/child_repository.dart';

// ============================================================================
// 📌 حالة استخدام إضافة طفل جديد (Add Child Use Case)
// ----------------------------------------------------------------------------
// يضيف ملف تعريف للطفل مع تحديد الحد اليومي لوقت الشاشة.
// ============================================================================

class AddChildUseCase {
  final ChildRepository repository;

  const AddChildUseCase(this.repository);

  Future<ChildEntity> execute({
    required String parentId,
    required String name,
    required int age,
    required int dailyScreenTimeLimitMinutes,
    String? avatarUrl,
  }) {
    return repository.addChild(
      parentId: parentId,
      name: name.trim(),
      age: age,
      dailyScreenTimeLimitMinutes: dailyScreenTimeLimitMinutes,
      avatarUrl: avatarUrl,
    );
  }
}
