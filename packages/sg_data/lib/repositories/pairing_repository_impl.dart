import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_pairing_datasource.dart';

// ============================================================================
// 📌 تطبيق مستودع أكواد الربط (Pairing Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة PairingRepository بمصدر بيانات Firestore للأكواد.
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
}
