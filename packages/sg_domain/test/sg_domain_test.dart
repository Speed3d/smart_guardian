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
}
