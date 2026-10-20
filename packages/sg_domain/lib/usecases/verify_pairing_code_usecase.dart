import 'package:sg_core/sg_core.dart';
import '../entities/device_entity.dart';
import '../entities/pairing_code_entity.dart';
import '../repositories/pairing_repository.dart';

// ============================================================================
// 📌 حالة استخدام التحقق من كود الربط (Verify Pairing Code Use Case)
// ----------------------------------------------------------------------------
// تنفذ التحقق من صحة الكود المُدخل في هاتف الطفل وتسجيل الجهاز وربطه بحساب الأب.
// ============================================================================

class VerifyPairingCodeUseCase {
  final PairingRepository repository;

  const VerifyPairingCodeUseCase(this.repository);

  /// التحقق من الكود وإتمام عملية الاقتران
  /// [code]: الرمز الرقمي المكون من 6 أرقام
  /// [deviceId]: المعرف الفريد لهاتف الطفل
  /// [deviceModel]: طراز الهاتف (مثل Samsung أو iPhone)
  /// [osVersion]: إصدار النظام
  Future<PairingCodeEntity> execute({
    required String code,
    required String deviceId,
    required String deviceModel,
    required String osVersion,
  }) async {
    final cleanCode = code.trim();
    if (cleanCode.length != AppConstants.pairingCodeLength) {
      throw const PairingFailure('يجب أن يتكون رمز الربط من 6 أرقام.');
    }

    // 1. التحقق من صلاحية الكود من Firestore
    final pairingCode = await repository.verifyPairingCode(cleanCode);
    if (pairingCode == null) {
      throw const PairingFailure('رمز الربط غير صحيح أو منتهي الصلاحية.');
    }

    if (pairingCode.isExpired) {
      throw const PairingFailure('انتهت صلاحية هذا الرمز، يرجى طلب رمز جديد من الأب.');
    }

    if (pairingCode.isUsed) {
      throw const PairingFailure('تم استخدام هذا الرمز مسبقاً.');
    }

    // 2. تسجيل جهاز الطفل في النظام
    final device = DeviceEntity(
      id: deviceId,
      childId: pairingCode.childId,
      parentId: pairingCode.parentId,
      model: deviceModel,
      osVersion: osVersion,
      isPaired: true,
      lastSeenAt: DateTime.now(),
    );
    await repository.registerDevice(device);

    // 3. وسم الكود كمستخدم لتعطيله
    await repository.markCodeAsUsed(pairingCode.id, deviceId);

    return pairingCode;
  }
}
