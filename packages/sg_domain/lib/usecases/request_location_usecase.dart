import 'package:sg_core/sg_core.dart';
import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام طلب الموقع الجغرافي الفوري (Request Location Use Case)
/// ----------------------------------------------------------------------------
/// يرسل أمراً فورياً لهاتف الطفل لإرسال إحداثيات GPS الحالية لولي الأمر عند الطلب.
/// ============================================================================

class RequestLocationUseCase {
  final CommandRepository _repository;

  const RequestLocationUseCase(this._repository);

  /// طلب الموقع
  Future<void> execute({
    required String childId,
    required String deviceId,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandRequestLocation,
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }
}
