import 'package:sg_core/sg_core.dart';
import '../entities/command_entity.dart';
import '../repositories/command_repository.dart';

/// ============================================================================
/// 📌 حالة استخدام إدارة حظر التطبيقات (Manage App Restriction Use Case)
/// ----------------------------------------------------------------------------
/// يرسل أمراً لحظر تطبيق معين (BLOCK_APP) أو فك الحظر عنه (UNBLOCK_APP)
/// لتطبيقها فوراً بواسطة خدمة سهولة الوصول في جهاز الطفل.
/// ============================================================================

class ManageAppRestrictionUseCase {
  final CommandRepository _repository;

  const ManageAppRestrictionUseCase(this._repository);

  /// حظر تطبيق معين
  Future<void> blockApp({
    required String childId,
    required String deviceId,
    required String packageName,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandBlockApp,
      payload: {'packageName': packageName},
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }

  /// إلغاء حظر تطبيق معين
  Future<void> unblockApp({
    required String childId,
    required String deviceId,
    required String packageName,
  }) async {
    final command = CommandEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: childId,
      deviceId: deviceId,
      action: AppConstants.commandUnblockApp,
      payload: {'packageName': packageName},
      status: CommandStatus.pending,
      createdAt: DateTime.now(),
    );

    await _repository.sendCommand(command);
  }
}
