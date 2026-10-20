import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(AppConstants.methodChannelName);
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'lockDevice':
          return true;
        case 'unlockDevice':
          return true;
        case 'isDeviceAdminActive':
          return true;
        case 'requestDeviceAdmin':
          return null;
        case 'setBlockedPackages':
          return true;
        case 'getBlockedPackages':
          return <String>['com.example.game', 'com.example.social'];
        case 'isAccessibilityServiceEnabled':
          return true;
        case 'requestAccessibilityPermission':
          return null;
        case 'startForegroundService':
          return true;
        case 'stopForegroundService':
          return true;
        case 'isForegroundServiceRunning':
          return true;
        case 'getDailyUsageStats':
          return <String, int>{
            'com.example.game': 45,
            'com.example.browser': 20,
          };
        case 'hasUsageStatsPermission':
          return true;
        case 'requestUsageStatsPermission':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('DeviceControlBridge Tests', () {
    test('lockDevice returns true when platform confirms', () async {
      final result = await DeviceControlBridge.lockDevice();
      expect(result, isTrue);
      expect(log.last.method, 'lockDevice');
    });

    test('unlockDevice returns true when platform confirms', () async {
      final result = await DeviceControlBridge.unlockDevice();
      expect(result, isTrue);
      expect(log.last.method, 'unlockDevice');
    });

    test('isDeviceAdminActive checks device admin status', () async {
      final result = await DeviceControlBridge.isDeviceAdminActive();
      expect(result, isTrue);
      expect(log.last.method, 'isDeviceAdminActive');
    });

    test('setBlockedPackages sends packages to platform', () async {
      final result = await DeviceControlBridge.setBlockedPackages(['com.test.app']);
      expect(result, isTrue);
      expect(log.last.method, 'setBlockedPackages');
      expect(log.last.arguments, {'packages': ['com.test.app']});
    });

    test('getBlockedPackages retrieves blocked packages', () async {
      final list = await DeviceControlBridge.getBlockedPackages();
      expect(list, ['com.example.game', 'com.example.social']);
      expect(log.last.method, 'getBlockedPackages');
    });

    test('isAccessibilityServiceEnabled returns boolean', () async {
      final result = await DeviceControlBridge.isAccessibilityServiceEnabled();
      expect(result, isTrue);
      expect(log.last.method, 'isAccessibilityServiceEnabled');
    });

    test('foreground service start, stop and running status', () async {
      final start = await DeviceControlBridge.startForegroundService();
      expect(start, isTrue);

      final isRunning = await DeviceControlBridge.isForegroundServiceRunning();
      expect(isRunning, isTrue);

      final stop = await DeviceControlBridge.stopForegroundService();
      expect(stop, isTrue);
    });
  });

  group('AppUsageBridge Tests', () {
    test('hasUsageStatsPermission returns permission state', () async {
      final result = await AppUsageBridge.hasUsageStatsPermission();
      expect(result, isTrue);
      expect(log.last.method, 'hasUsageStatsPermission');
    });

    test('getDailyUsageStats returns map of package to minutes', () async {
      final stats = await AppUsageBridge.getDailyUsageStats();
      expect(stats, {
        'com.example.game': 45,
        'com.example.browser': 20,
      });
      expect(log.last.method, 'getDailyUsageStats');
    });
  });
}
