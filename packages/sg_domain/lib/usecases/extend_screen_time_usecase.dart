import 'package:sg_core/sg_core.dart';
import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام تمديد وقت الشاشة (Extend Screen Time Use Case)
/// ----------------------------------------------------------------------------
/// يرسل أمراً فورياً لجهاز الطفل لزيادة وقت الشاشة المتاح بالدقائق (مثلاً +15 أو +30 دقيقة).
/// ============================================================================

class ExtendScreenTimeUseCase {
  final CommandRepository _repository;

  const ExtendScreenTimeUseCase(this._repository);

  /// تنفيذ تمديد الوقت
  Future<void> execute({
    required String childId,
    required String deviceId,
    required int additionalMinutes,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandExtendScreenTime,
      payload: {'extraMinutes': additionalMinutes},
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }
}
