import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sg_core/sg_core.dart';
import '../../models/device_model.dart';
import '../../models/pairing_code_model.dart';

// ============================================================================
// 📌 مصدر بيانات أكواد الربط من Firestore (Firestore Pairing DataSource)
// ----------------------------------------------------------------------------
// يولد كوداً عشوائياً مكوناً من 6 أرقام ويخزنه في مجموعة pairing_codes مع وقت انتهاء الصلاحية.
// ============================================================================

abstract class FirestorePairingDataSource {
  Future<PairingCodeModel> generatePairingCode(String parentId, String childId);
  Future<PairingCodeModel?> verifyPairingCode(String code);
  Future<void> markCodeAsUsed(String codeId, String deviceId);
  Future<void> registerDevice(DeviceModel device);
}

class FirestorePairingDataSourceImpl implements FirestorePairingDataSource {
  final FirebaseFirestore _firestore;

  FirestorePairingDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _pairingCollection =>
      _firestore.collection(AppConstants.pairingCodesCollection);

  CollectionReference<Map<String, dynamic>> get _devicesCollection =>
      _firestore.collection(AppConstants.devicesCollection);

  @override
  Future<PairingCodeModel> generatePairingCode(
      String parentId, String childId) async {
    try {
      final random = Random.secure();
      final codeString = (100000 + random.nextInt(900000)).toString();
      final expiresAt = DateTime.now().add(const Duration(
          minutes: AppConstants.pairingCodeValidityMinutes));

      final docRef = await _pairingCollection.add({
        'code': codeString,
        'parentId': parentId,
        'childId': childId,
        'expiresAt': expiresAt.millisecondsSinceEpoch,
        'isUsed': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return PairingCodeModel(
        id: docRef.id,
        code: codeString,
        parentId: parentId,
        childId: childId,
        expiresAt: expiresAt,
        isUsed: false,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PairingCodeModel?> verifyPairingCode(String code) async {
    try {
      final query = await _pairingCollection
          .where('code', isEqualTo: code.trim())
          .where('isUsed', isEqualTo: false)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final model = PairingCodeModel.fromMap(doc.data(), doc.id);
      if (model.isExpired) return null;

      return model;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markCodeAsUsed(String codeId, String deviceId) async {
    try {
      await _pairingCollection.doc(codeId).update({
        'isUsed': true,
        'usedDeviceId': deviceId,
        'usedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> registerDevice(DeviceModel device) async {
    try {
      await _devicesCollection.doc(device.id).set(device.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
