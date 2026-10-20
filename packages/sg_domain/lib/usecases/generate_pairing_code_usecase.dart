import '../entities/pairing_code_entity.dart';
import '../repositories/pairing_repository.dart';

// ============================================================================
// 📌 حالة استخدام توليد كود الربط (Generate Pairing Code Use Case)
// ----------------------------------------------------------------------------
// يطلب توليد كود رقمي مؤقت صالح لربط هاتف الطفل.
// ============================================================================

class GeneratePairingCodeUseCase {
  final PairingRepository repository;

  const GeneratePairingCodeUseCase(this.repository);

  Future<PairingCodeEntity> execute({
    required String parentId,
    required String childId,
  }) {
    return repository.generatePairingCode(
      parentId: parentId,
      childId: childId,
    );
  }
}
