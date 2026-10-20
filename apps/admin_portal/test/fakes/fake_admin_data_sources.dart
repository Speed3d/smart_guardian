import 'dart:async';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

class FakeAdminChildDataSource implements FirestoreChildDataSource {
  @override
  Future<ChildModel> addChild(ChildModel child) async => child;

  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) async {}

  @override
  Future<ChildModel?> getChildById(String childId) async => null;

  @override
  Stream<List<ChildModel>> getChildrenStream(String parentId) =>
      Stream.value([]);

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) async {}

  @override
  Future<void> updateDailyLimit(String childId, int limitMinutes) async {}
}

class FakeAdminCommandDataSource implements FirestoreCommandDataSource {
  final List<CommandModel> commands = [];

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) =>
      const Stream.empty();

  @override
  Stream<List<CommandModel>> listenToRecentCommands(String childId) =>
      Stream.value(commands);

  @override
  Future<void> sendCommand(CommandModel command) async {
    commands.add(command);
  }

  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {}
}

class FakeAdminPairingDataSource implements FirestorePairingDataSource {
  @override
  Future<PairingCodeModel> generatePairingCode(
      String parentId, String childId) async {
    return PairingCodeModel(
      id: 'p1',
      code: '123456',
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
  Future<PairingCodeModel?> verifyPairingCode(String code) async => null;
}

class FakeAdminUsageDataSource implements FirestoreUsageDataSource {
  @override
  Future<void> saveUsageReport(UsageReportModel report) async {}

  @override
  Future<UsageReportModel?> getUsageReport(String childId, String date) async => null;

  @override
  Stream<UsageReportModel?> listenUsageReport(String childId, String date) =>
      Stream.value(null);
}
