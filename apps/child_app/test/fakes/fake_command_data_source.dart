import 'dart:async';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

class FakeCommandDataSource implements FirestoreCommandDataSource {
  final _controller = StreamController<CommandModel>.broadcast();

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) =>
      _controller.stream;

  @override
  Future<void> sendCommand(CommandModel command) async {}

  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {}
}

class FakePairingDataSource implements FirestorePairingDataSource {
  @override
  Future<PairingCodeModel> generatePairingCode(
      String parentId, String childId) async {
    return PairingCodeModel(
      id: 'pairing_1',
      code: '582914',
      parentId: parentId,
      childId: childId,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      isUsed: false,
    );
  }

  @override
  Future<void> markCodeAsUsed(String codeId, String deviceId) async {}

  @override
  Future<void> registerDevice(DeviceModel device) async {}

  @override
  Future<PairingCodeModel?> verifyPairingCode(String code) async {
    if (code == '582914') {
      return PairingCodeModel(
        id: 'pairing_1',
        code: '582914',
        parentId: 'mock_parent_1',
        childId: 'mock_child_1',
        expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        isUsed: false,
      );
    }
    return null;
  }
}
