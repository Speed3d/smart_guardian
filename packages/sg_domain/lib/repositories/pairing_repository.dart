import '../entities/device_entity.dart';
import '../entities/pairing_code_entity.dart';

// ============================================================================
// 📌 واجهة مستودع أكواد الربط (Pairing Repository Interface)
// ----------------------------------------------------------------------------
// عقد تجريدي لتوليد أكواد الربط والتحقق من صحتها وتسجيل جهاز الطفل في النظام.
// ============================================================================

abstract class PairingRepository {
  /// توليد كود ربط مؤقت صالح لمدة 10 دقائق
  Future<PairingCodeEntity> generatePairingCode({
    required String parentId,
    required String childId,
  });

  /// التحقق من كود الربط عند إدخاله في تطبيق الطفل
  Future<PairingCodeEntity?> verifyPairingCode(String code);

  /// وسم الكود كمستخدم بعد نجاح الربط
  Future<void> markCodeAsUsed(String codeId, String deviceId);

  /// تسجيل جهاز الطفل في Firestore بعد نجاح الاقتران
  Future<void> registerDevice(DeviceEntity device);
}
