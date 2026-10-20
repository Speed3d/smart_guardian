import 'package:flutter/services.dart';
import 'package:sg_core/sg_core.dart';

/// ============================================================================
/// 📌 جسر التحكم بالجهاز الأصلي (Native Device Control Bridge)
/// ----------------------------------------------------------------------------
/// يربط كود Dart بالأكواد الأصلية:
/// - في أندرويد: يستدعي DevicePolicyManager و AccessibilityService عبر MethodChannel.
/// - في آبل: يستدعي ManagedSettings و FamilyControls عبر Swift Platform Channel.
/// ============================================================================

class DeviceControlBridge {
  static const MethodChannel _channel = MethodChannel(AppConstants.methodChannelName);

  const DeviceControlBridge._();

  /// قفل شاشة جهاز الطفل فوراً
  static Future<bool> lockDevice() async {
    try {
      final result = await _channel.invokeMethod<bool>('lockDevice');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل قفل الجهاز عبر القناة الأصلية',
        platform: e.code,
      );
    }
  }

  /// فتح قفل شاشة جهاز الطفل
  static Future<bool> unlockDevice() async {
    try {
      final result = await _channel.invokeMethod<bool>('unlockDevice');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل إلغاء قفل الجهاز عبر القناة الأصلية',
        platform: e.code,
      );
    }
  }

  /// التحقق من منح صلاحية إدارة الجهاز (Device Admin في أندرويد)
  static Future<bool> isDeviceAdminActive() async {
    try {
      final result = await _channel.invokeMethod<bool>('isDeviceAdminActive');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل التحقق من صلاحية إدارة الجهاز',
        platform: e.code,
      );
    }
  }

  /// طلب تفعيل صلاحية إدارة الجهاز من إعدادات النظام
  static Future<void> requestDeviceAdmin() async {
    try {
      await _channel.invokeMethod<void>('requestDeviceAdmin');
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل طلب صلاحية إدارة الجهاز',
        platform: e.code,
      );
    }
  }
}
