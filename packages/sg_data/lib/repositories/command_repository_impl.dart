import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firestore_command_datasource.dart';
import '../models/command_model.dart';

// ============================================================================
// 📌 تطبيق مستودع الأوامر (Command Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة CommandRepository بمصدر بيانات الأوامر في Firestore.
// ============================================================================

class CommandRepositoryImpl implements CommandRepository {
  final FirestoreCommandDataSource _dataSource;

  CommandRepositoryImpl(this._dataSource);

  @override
  Future<void> sendCommand(CommandEntity command) {
    final model = CommandModel(
      id: command.id,
      childId: command.childId,
      deviceId: command.deviceId,
      action: command.action,
      payload: command.payload,
      status: command.status,
      createdAt: command.createdAt,
    );
    return _dataSource.sendCommand(model);
  }

  @override
  Stream<CommandEntity> listenToChildCommands(String childId, String deviceId) {
    return _dataSource.listenToCommands(childId, deviceId);
  }

  @override
  Future<void> updateCommandStatus(String commandId, CommandStatus status) {
    return _dataSource.updateCommandStatus(commandId, status);
  }
}
