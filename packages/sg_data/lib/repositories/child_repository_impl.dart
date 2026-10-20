import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_child_datasource.dart';
import '../models/child_model.dart';

// ============================================================================
// 📌 تطبيق مستودع الأطفال (Child Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة ChildRepository بمصدر بيانات Firestore.
// ============================================================================

class ChildRepositoryImpl implements ChildRepository {
  final FirestoreChildDataSource _dataSource;

  ChildRepositoryImpl(this._dataSource);

  @override
  Stream<List<ChildEntity>> getChildrenStream(String parentId) {
    return _dataSource.getChildrenStream(parentId);
  }

  @override
  Future<ChildEntity> addChild({
    required String parentId,
    required String name,
    required int age,
    required int dailyScreenTimeLimitMinutes,
    String? avatarUrl,
  }) {
    final model = ChildModel(
      id: '',
      parentId: parentId,
      name: name,
      age: age,
      avatarUrl: avatarUrl,
      dailyScreenTimeLimitMinutes: dailyScreenTimeLimitMinutes,
      usedScreenTimeTodayMinutes: 0,
      isLocked: false,
      lastActiveAt: DateTime.now(),
    );
    return _dataSource.addChild(model);
  }

  @override
  Future<ChildEntity?> getChildById(String childId) {
    return _dataSource.getChildById(childId);
  }

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) {
    return _dataSource.updateChildLockStatus(childId, isLocked);
  }

  @override
  Future<void> updateDailyScreenTimeLimit(String childId, int limitMinutes) {
    return _dataSource.updateDailyLimit(childId, limitMinutes);
  }

  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) {
    return _dataSource.extendScreenTime(childId, additionalMinutes);
  }
}
