import 'dart:async';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

class FakeAuthDataSource implements FirebaseAuthDataSource {
  final _controller = StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  UserModel? getCurrentUser() => UserModel(
        id: 'mock_parent_1',
        email: 'parent@example.com',
        displayName: 'ولي الأمر',
        createdAt: DateTime(2026, 1, 1),
      );

  @override
  Future<UserModel> registerWithEmailAndPassword(
          String email, String password, String displayName) async =>
      getCurrentUser()!;

  @override
  Future<UserModel> signInWithEmailAndPassword(
          String email, String password) async =>
      getCurrentUser()!;

  @override
  Future<void> signOut() async => _controller.add(null);
}

class FakeChildDataSource implements FirestoreChildDataSource {
  @override
  Future<ChildModel> addChild(ChildModel child) async => child;

  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) async {}

  @override
  Future<ChildModel?> getChildById(String childId) async => null;

  @override
  Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return Stream.value([
      ChildModel(
        id: 'child_1',
        parentId: parentId,
        name: 'أحمد',
        age: 10,
        dailyScreenTimeLimitMinutes: 120,
        usedScreenTimeTodayMinutes: 45,
        isLocked: false,
        lastActiveAt: DateTime(2026, 1, 1),
      )
    ]);
  }

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) async {}

  @override
  Future<void> updateDailyLimit(String childId, int limitMinutes) async {}
}

class FakeCommandDataSource implements FirestoreCommandDataSource {
  final _controller = StreamController<CommandModel>.broadcast();

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) =>
      _controller.stream;

  @override
  Stream<List<CommandModel>> listenToRecentCommands(String childId) {
    return Stream.value([
      CommandModel(
        id: 'cmd_1',
        childId: childId,
        deviceId: 'device_1',
        action: 'LOCK_DEVICE',
        status: CommandStatus.executed,
        createdAt: DateTime.now(),
      )
    ]);
  }

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

class FakeUsageDataSource implements FirestoreUsageDataSource {
  @override
  Future<void> saveUsageReport(UsageReportModel report) async {}

  @override
  Future<UsageReportModel?> getUsageReport(String childId, String date) async => null;

  @override
  Stream<UsageReportModel?> listenUsageReport(String childId, String date) =>
      Stream.value(null);
}
