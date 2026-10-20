import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_pairing_datasource.dart';
import '../models/device_model.dart';

// ============================================================================
// 📌 تطبيق مستودع أكواد الربط (Pairing Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة PairingRepository بمصدر بيانات Firestore للأكواد وتسجيل الأجهزة.
// ============================================================================

class PairingRepositoryImpl implements PairingRepository {
  final FirestorePairingDataSource dataSource;

  PairingRepositoryImpl(this.dataSource);

  @override
  Future<PairingCodeEntity> generatePairingCode({
    required String parentId,
    required String childId,
  }) {
    return dataSource.generatePairingCode(parentId, childId);
  }

  @override
  Future<PairingCodeEntity?> verifyPairingCode(String code) {
    return dataSource.verifyPairingCode(code);
  }

  @override
  Future<void> markCodeAsUsed(String codeId, String deviceId) {
    return dataSource.markCodeAsUsed(codeId, deviceId);
  }

  @override
  Future<void> registerDevice(DeviceEntity device) {
    final model = DeviceModel(
      id: device.id,
      childId: device.childId,
      parentId: device.parentId,
      model: device.model,
      osVersion: device.osVersion,
      isPaired: device.isPaired,
      batteryLevel: device.batteryLevel,
      lastSeenAt: device.lastSeenAt,
    );
    return dataSource.registerDevice(model);
  }
}
