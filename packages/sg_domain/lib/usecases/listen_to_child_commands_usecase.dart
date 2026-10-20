import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام الاستماع لأوامر الطفل (Listen To Child Commands Use Case)
/// ----------------------------------------------------------------------------
/// يفتح قناة استماع حية للأوامر المعلقة الصادرة لجهاز الطفل لتنفيذها محلياً فوراً.
/// ============================================================================

class ListenToChildCommandsUseCase {
  final CommandRepository _repository;

  const ListenToChildCommandsUseCase(this._repository);

  Stream<CommandEntity> execute(String childId, String deviceId) {
    return _repository.listenToChildCommands(childId, deviceId);
  }
}
