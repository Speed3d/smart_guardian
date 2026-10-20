import 'package:sg_core/sg_core.dart';
import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام قفل الجهاز (Lock Device Use Case)
/// ----------------------------------------------------------------------------
/// ينفذ منطق قفل جهاز الطفل فورياً عند ضغط الأب على زر القفل في تطبيقه.
/// ============================================================================

class LockDeviceUseCase {
  final CommandRepository _repository;

  const LockDeviceUseCase(this._repository);

  /// تنفيذ عملية القفل
  /// [childId]: معرف الطفل
  /// [deviceId]: معرف الجهاز المستهدف
  Future<void> execute({
    required String childId,
    required String deviceId,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandLockDevice,
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }
}
