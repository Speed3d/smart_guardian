import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:test/test.dart';

class FakeTestPairingRepository implements PairingRepository {
  @override
  Future<PairingCodeEntity> generatePairingCode(
      {required String parentId, required String childId}) async {
    return PairingCodeEntity(
      id: 'code_1',
      code: '123456',
      parentId: parentId,
      childId: childId,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<void> markCodeAsUsed(String codeId, String deviceId) async {}

  @override
  Future<void> registerDevice(DeviceEntity device) async {}

  @override
  Future<PairingCodeEntity?> verifyPairingCode(String code) async {
    if (code == '123456') {
      return PairingCodeEntity(
        id: 'code_1',
        code: '123456',
        parentId: 'parent_1',
        childId: 'child_1',
        expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        isUsed: false,
      );
    }
    return null;
  }
}

class FakeTestCommandRepository implements CommandRepository {
  final List<CommandEntity> sentCommands = [];

  @override
  Future<void> sendCommand(CommandEntity command) async {
    sentCommands.add(command);
  }

  @override
  Stream<CommandEntity> listenToChildCommands(String childId, String deviceId) =>
      const Stream.empty();

  @override
  Stream<List<CommandEntity>> listenToRecentCommands(String childId) =>
      Stream.value(sentCommands);

  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {}
}

class FakeTestUsageRepository implements UsageRepository {
  DailyUsageReportEntity? savedReport;

  @override
  Future<void> saveDailyUsageReport(DailyUsageReportEntity report) async {
    savedReport = report;
  }

  @override
  Future<DailyUsageReportEntity?> getDailyUsageReport(
      String childId, String date) async => savedReport;

  @override
  Stream<DailyUsageReportEntity?> listenDailyUsageReport(
      String childId, String date) => Stream.value(savedReport);
}

void main() {
  group('ChildEntity Tests', () {
    test('Calculates remaining minutes and exhaustion correctly', () {
      final child = ChildEntity(
        id: 'child_1',
        parentId: 'parent_1',
        name: 'أحمد',
        age: 10,
        dailyScreenTimeLimitMinutes: 120,
        usedScreenTimeTodayMinutes: 80,
        isLocked: false,
        lastActiveAt: DateTime.now(),
      );

      expect(child.remainingMinutes, 40);
      expect(child.hasExhaustedTime, false);
    });
  });

  group('VerifyPairingCodeUseCase Tests', () {
    late VerifyPairingCodeUseCase useCase;

    setUp(() {
      useCase = VerifyPairingCodeUseCase(FakeTestPairingRepository());
    });

    test('Throws PairingFailure if code is not 6 digits', () async {
      expect(
        () => useCase.execute(
          code: '123',
          deviceId: 'dev_1',
          deviceModel: 'Model',
          osVersion: 'Android',
        ),
        throwsA(isA<PairingFailure>()),
      );
    });

    test('Successfully verifies valid 6-digit code', () async {
      final result = await useCase.execute(
        code: '123456',
        deviceId: 'dev_1',
        deviceModel: 'Samsung A54',
        osVersion: 'Android 14',
      );

      expect(result.code, '123456');
      expect(result.childId, 'child_1');
    });

    test('Throws PairingFailure for wrong code', () async {
      expect(
        () => useCase.execute(
          code: '999999',
          deviceId: 'dev_1',
          deviceModel: 'Model',
          osVersion: 'Android',
        ),
        throwsA(isA<PairingFailure>()),
      );
    });
  });

  group('Command Use Cases Tests', () {
    late FakeTestCommandRepository commandRepo;

    setUp(() {
      commandRepo = FakeTestCommandRepository();
    });

    test('LockDeviceUseCase sends LOCK_DEVICE command', () async {
      final useCase = LockDeviceUseCase(commandRepo);
      await useCase.execute(childId: 'child_1', deviceId: 'dev_1');

      expect(commandRepo.sentCommands.length, 1);
      expect(commandRepo.sentCommands.first.action, AppConstants.commandLockDevice);
      expect(commandRepo.sentCommands.first.childId, 'child_1');
    });

    test('UnlockDeviceUseCase sends UNLOCK_DEVICE command', () async {
      final useCase = UnlockDeviceUseCase(commandRepo);
      await useCase.execute(childId: 'child_1', deviceId: 'dev_1');

      expect(commandRepo.sentCommands.length, 1);
      expect(commandRepo.sentCommands.first.action, AppConstants.commandUnlockDevice);
    });

    test('ExtendScreenTimeUseCase sends EXTEND_SCREEN_TIME with extra minutes', () async {
      final useCase = ExtendScreenTimeUseCase(commandRepo);
      await useCase.execute(childId: 'child_1', deviceId: 'dev_1', additionalMinutes: 30);

      expect(commandRepo.sentCommands.length, 1);
      expect(commandRepo.sentCommands.first.action, AppConstants.commandExtendScreenTime);
      expect(commandRepo.sentCommands.first.payload?['extraMinutes'], 30);
    });

    test('ManageAppRestrictionUseCase blocks and unblocks app package', () async {
      final useCase = ManageAppRestrictionUseCase(commandRepo);
      await useCase.blockApp(childId: 'child_1', deviceId: 'dev_1', packageName: 'com.test.game');
      await useCase.unblockApp(childId: 'child_1', deviceId: 'dev_1', packageName: 'com.test.game');

      expect(commandRepo.sentCommands.length, 2);
      expect(commandRepo.sentCommands[0].action, AppConstants.commandBlockApp);
      expect(commandRepo.sentCommands[0].payload?['packageName'], 'com.test.game');
      expect(commandRepo.sentCommands[1].action, AppConstants.commandUnblockApp);
    });
  });

  group('SyncDailyUsageUseCase Tests', () {
    test('Aggregates apps usage and saves daily report', () async {
      final usageRepo = FakeTestUsageRepository();
      final useCase = SyncDailyUsageUseCase(usageRepo);

      await useCase.execute(
        childId: 'child_1',
        deviceId: 'dev_1',
        date: '2026-10-20',
        appUsageMinutes: {
          'com.youtube': 40,
          'com.game': 50,
        },
      );

      expect(usageRepo.savedReport, isNotNull);
      expect(usageRepo.savedReport!.totalScreenTimeMinutes, 90);
      expect(usageRepo.savedReport!.appUsageMinutes['com.youtube'], 40);
      expect(usageRepo.savedReport!.id, 'child_1_2026-10-20');
    });
  });
}
