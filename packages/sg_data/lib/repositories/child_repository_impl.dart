import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_child_datasource.dart';

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
