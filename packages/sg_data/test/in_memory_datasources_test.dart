import 'package:flutter_test/flutter_test.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

void main() {
  group('InMemory DataSources Tests', () {
    test('InMemoryAuthDataSource sign in, state changes and sign out', () async {
      final auth = InMemoryAuthDataSource();
      expect(auth.getCurrentUser(), isNotNull);
      expect(auth.getCurrentUser()?.email, 'parent@smartguardian.com');

      final user = await auth.signInWithEmailAndPassword('test@example.com', '123456');
      expect(user.email, 'test@example.com');
      expect(auth.getCurrentUser()?.email, 'test@example.com');

      await auth.signOut();
      expect(auth.getCurrentUser(), isNull);
    });

    test('InMemoryChildDataSource stream and lock updates', () async {
      final childDs = InMemoryChildDataSource();
      final streamFuture = childDs.getChildrenStream('demo_parent_id').first;
      final initialChildren = await streamFuture;
      expect(initialChildren.length, 2);

      await childDs.updateChildLockStatus('demo_child_1', true);
      final updated = await childDs.getChildById('demo_child_1');
      expect(updated?.isLocked, true);

      await childDs.extendScreenTime('demo_child_1', 30);
      final extended = await childDs.getChildById('demo_child_1');
      expect(extended?.dailyScreenTimeLimitMinutes, 150);
      expect(extended?.isLocked, false);
    });

    test('InMemoryPairingDataSource generates and verifies 6-digit codes', () async {
      final pairing = InMemoryPairingDataSource();
      final generated = await pairing.generatePairingCode('p1', 'c1');
      expect(generated.code.length, 6);

      final verified = await pairing.verifyPairingCode('842915');
      expect(verified, isNotNull);
      expect(verified?.code, '842915');

      final invalid = await pairing.verifyPairingCode('12');
      expect(invalid, isNull);
    });

    test('InMemoryCommandDataSource sends and listens to commands', () async {
      final commandDs = InMemoryCommandDataSource();
      final stream = commandDs.listenToCommands('child_1', 'dev_1');

      final cmd = CommandModel(
        id: 'cmd_1',
        childId: 'child_1',
        deviceId: 'dev_1',
        action: AppConstants.commandLockDevice,
        status: CommandStatus.pending,
        createdAt: DateTime.now(),
      );

      expectLater(stream, emits(cmd));
      await commandDs.sendCommand(cmd);
    });

    test('InMemoryUsageDataSource saves and retrieves daily reports', () async {
      final usageDs = InMemoryUsageDataSource();
      final report = UsageReportModel(
        id: 'child_1_2026-10-21',
        childId: 'child_1',
        deviceId: 'dev_1',
        date: '2026-10-21',
        totalScreenTimeMinutes: 120,
        appUsageMinutes: const {'com.youtube': 60},
        updatedAt: DateTime.now(),
      );

      await usageDs.saveUsageReport(report);
      final fetched = await usageDs.getUsageReport('child_1', '2026-10-21');
      expect(fetched?.totalScreenTimeMinutes, 120);
      expect(fetched?.appUsageMinutes['com.youtube'], 60);
    });
  });
}
