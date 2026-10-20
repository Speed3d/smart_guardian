import 'package:sg_core/sg_core.dart';
import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام إلغاء قفل الجهاز (Unlock Device Use Case)
/// ----------------------------------------------------------------------------
/// ينفذ منطق إرسال أمر فك قفل هاتف الطفل عند رغبة الأب بالسماح له بالاستخدام.
/// ============================================================================

class UnlockDeviceUseCase {
  final CommandRepository _repository;

  const UnlockDeviceUseCase(this._repository);

  /// تنفيذ عملية فك القفل
  Future<void> execute({
    required String childId,
    required String deviceId,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandUnlockDevice,
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }
}
