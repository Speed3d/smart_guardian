import '../entities/child_entity.dart';
import '../repositories/child_repository.dart';

// ============================================================================
// 📌 حالة استخدام جلب قائمة الأطفال (Get Children Use Case)
// ----------------------------------------------------------------------------
// تعيد تدفقاً حياً (Stream) بقائمة الأطفال التابعين لولي الأمر.
// ============================================================================

class GetChildrenUseCase {
  final ChildRepository _repository;

  const GetChildrenUseCase(this._repository);

  Stream<List<ChildEntity>> execute(String parentId) {
    return _repository.getChildrenStream(parentId);
  }
}
