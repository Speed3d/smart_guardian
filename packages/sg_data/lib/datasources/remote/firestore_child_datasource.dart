import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sg_core/sg_core.dart';
import '../../models/child_model.dart';

// ============================================================================
// 📌 مصدر بيانات الأطفال من Firestore (Firestore Child DataSource)
// ----------------------------------------------------------------------------
// يربط التطبيق بمجموعة children في Cloud Firestore ويوفر التحديث اللحظي.
// ============================================================================

abstract class FirestoreChildDataSource {
  Stream<List<ChildModel>> getChildrenStream(String parentId);
  Future<ChildModel> addChild(ChildModel child);
  Future<ChildModel?> getChildById(String childId);
  Future<void> updateChildLockStatus(String childId, bool isLocked);
  Future<void> updateDailyLimit(String childId, int limitMinutes);
  Future<void> extendScreenTime(String childId, int additionalMinutes);
}

class FirestoreChildDataSourceImpl implements FirestoreChildDataSource {
  final FirebaseFirestore _firestore;

  FirestoreChildDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _childrenCollection =>
      _firestore.collection(AppConstants.childrenCollection);

  @override
  Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return _childrenCollection
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<ChildModel> addChild(ChildModel child) async {
    try {
      final docRef = await _childrenCollection.add(child.toMap());
      return ChildModel(
        id: docRef.id,
        parentId: child.parentId,
        name: child.name,
        age: child.age,
        avatarUrl: child.avatarUrl,
        dailyScreenTimeLimitMinutes: child.dailyScreenTimeLimitMinutes,
        usedScreenTimeTodayMinutes: child.usedScreenTimeTodayMinutes,
        isLocked: child.isLocked,
        lastActiveAt: child.lastActiveAt,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChildModel?> getChildById(String childId) async {
    try {
      final doc = await _childrenCollection.doc(childId).get();
      if (!doc.exists || doc.data() == null) return null;
      return ChildModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) async {
    try {
      await _childrenCollection.doc(childId).update({
        'isLocked': isLocked,
        'lastActiveAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateDailyLimit(String childId, int limitMinutes) async {
    try {
      await _childrenCollection.doc(childId).update({
        'dailyScreenTimeLimitMinutes': limitMinutes,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) async {
    try {
      await _childrenCollection.doc(childId).update({
        'dailyScreenTimeLimitMinutes':
            FieldValue.increment(additionalMinutes),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
