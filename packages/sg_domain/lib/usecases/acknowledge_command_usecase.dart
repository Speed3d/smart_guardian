import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام تأكيد تنفيذ الأمر (Acknowledge Command Use Case)
/// ----------------------------------------------------------------------------
/// يحدث حالة الأمر في Firestore (إلى EXECUTED أو FAILED) لإعلام الأب
/// بأن الأمر تم تطبيقه بنجاح على نظام التشغيل الأصلي.
/// ============================================================================

class AcknowledgeCommandUseCase {
  final CommandRepository _repository;

  const AcknowledgeCommandUseCase(this._repository);

  Future<void> execute({
    required String commandId,
    required CommandStatus status,
  }) {
    return _repository.updateCommandStatus(commandId, status);
  }
}
