import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:child_app/features/status/domain/child_command_dispatcher.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';

class MockListenToCommandsUseCase extends ListenToChildCommandsUseCase {
  final StreamController<CommandEntity> controller =
      StreamController<CommandEntity>.broadcast();

  MockListenToCommandsUseCase() : super(FakeCommandRepo());

  @override
  Stream<CommandEntity> execute(String childId, String deviceId) =>
      controller.stream;
}

class MockAcknowledgeCommandUseCase extends AcknowledgeCommandUseCase {
  final List<String> acknowledged = [];

  MockAcknowledgeCommandUseCase() : super(FakeCommandRepo());

  @override
  Future<void> execute({
    required String commandId,
    required CommandStatus status,
  }) async {
    acknowledged.add('$commandId:${status.name}');
  }
}

class FakeCommandRepo implements CommandRepository {
  @override
  Future<void> sendCommand(CommandEntity command) async {}
  @override
  Stream<CommandEntity> listenToChildCommands(String childId, String deviceId) =>
      const Stream.empty();
  @override
  Stream<List<CommandEntity>> listenToRecentCommands(String childId) =>
      const Stream.empty();
  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(AppConstants.methodChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'lockDevice':
        case 'unlockDevice':
          return true;
        case 'setBlockedPackages':
          return true;
        case 'getBlockedPackages':
          return <String>['com.old.blocked'];
        default:
          return true;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('ChildCommandDispatcher Tests', () {
    late MockListenToCommandsUseCase mockListen;
    late MockAcknowledgeCommandUseCase mockAck;
    late ChildCommandDispatcher dispatcher;

    setUp(() {
      mockListen = MockListenToCommandsUseCase();
      mockAck = MockAcknowledgeCommandUseCase();
      dispatcher = ChildCommandDispatcher(
        listenToCommandsUseCase: mockListen,
        acknowledgeCommandUseCase: mockAck,
      );
    });

    tearDown(() {
      dispatcher.dispose();
      mockListen.controller.close();
    });

    test('Dispatches LOCK_DEVICE and triggers onLockStateChanged', () async {
      bool? lockState;
      dispatcher.onLockStateChanged = (locked) => lockState = locked;

      dispatcher.startListening(childId: 'child_1', deviceId: 'dev_1');

      mockListen.controller.add(CommandEntity(
        id: 'cmd_1',
        childId: 'child_1',
        deviceId: 'dev_1',
        action: AppConstants.commandLockDevice,
        status: CommandStatus.pending,
        createdAt: DateTime.now(),
      ));

      await Future.delayed(const Duration(milliseconds: 50));

      expect(lockState, isTrue);
      expect(mockAck.acknowledged, contains('cmd_1:executed'));
    });

    test('Dispatches UNLOCK_DEVICE and triggers onLockStateChanged(false)', () async {
      bool? lockState;
      dispatcher.onLockStateChanged = (locked) => lockState = locked;

      dispatcher.startListening(childId: 'child_1', deviceId: 'dev_1');

      mockListen.controller.add(CommandEntity(
        id: 'cmd_2',
        childId: 'child_1',
        deviceId: 'dev_1',
        action: AppConstants.commandUnlockDevice,
        status: CommandStatus.pending,
        createdAt: DateTime.now(),
      ));

      await Future.delayed(const Duration(milliseconds: 50));

      expect(lockState, isFalse);
      expect(mockAck.acknowledged, contains('cmd_2:executed'));
    });

    test('Dispatches EXTEND_SCREEN_TIME and triggers onTimeExtended', () async {
      int? addedMinutes;
      dispatcher.onTimeExtended = (minutes) => addedMinutes = minutes;

      dispatcher.startListening(childId: 'child_1', deviceId: 'dev_1');

      mockListen.controller.add(CommandEntity(
        id: 'cmd_3',
        childId: 'child_1',
        deviceId: 'dev_1',
        action: AppConstants.commandExtendScreenTime,
        payload: {'extraMinutes': 30},
        status: CommandStatus.pending,
        createdAt: DateTime.now(),
      ));

      await Future.delayed(const Duration(milliseconds: 50));

      expect(addedMinutes, 30);
      expect(mockAck.acknowledged, contains('cmd_3:executed'));
    });

    test('Dispatches BLOCK_APP and updates native blocked packages', () async {
      List<String>? updatedPackages;
      dispatcher.onBlockedAppsChanged = (pkgs) => updatedPackages = pkgs;

      dispatcher.startListening(childId: 'child_1', deviceId: 'dev_1');

      mockListen.controller.add(CommandEntity(
        id: 'cmd_4',
        childId: 'child_1',
        deviceId: 'dev_1',
        action: AppConstants.commandBlockApp,
        payload: {'packageName': 'com.new.game'},
        status: CommandStatus.pending,
        createdAt: DateTime.now(),
      ));

      await Future.delayed(const Duration(milliseconds: 50));

      expect(updatedPackages, contains('com.new.game'));
      expect(mockAck.acknowledged, contains('cmd_4:executed'));
    });
  });
}
