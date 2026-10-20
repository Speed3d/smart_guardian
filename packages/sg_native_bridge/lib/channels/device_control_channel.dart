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

  /// فتح قفل شاشة جهاز الطفل أو إيقاظها
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

  /// إرسال وتحديث قائمة الحزم والتطبيقات المحظورة للخدمة الأصلية
  static Future<bool> setBlockedPackages(List<String> packages) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'setBlockedPackages',
        {'packages': packages},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل تحديث قائمة التطبيقات المحظورة',
        platform: e.code,
      );
    }
  }

  /// جلب قائمة أسماء الحزم المحظورة حالياً
  static Future<List<String>> getBlockedPackages() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod<List<dynamic>>('getBlockedPackages');
      if (result == null) return [];
      return result.map((e) => e.toString()).toList();
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل جلب قائمة التطبيقات المحظورة',
        platform: e.code,
      );
    }
  }

  /// التحقق من تفعيل خدمة سهولة الوصول (Accessibility Service)
  static Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAccessibilityServiceEnabled');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل فحص حالة خدمة سهولة الوصول',
        platform: e.code,
      );
    }
  }

  /// فتح شاشة إعدادات خدمة سهولة الوصول لتفعيلها
  static Future<void> requestAccessibilityPermission() async {
    try {
      await _channel.invokeMethod<void>('requestAccessibilityPermission');
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل فتح شاشة إعدادات سهولة الوصول',
        platform: e.code,
      );
    }
  }

  /// تشغيل الخدمة الدائمة في الخلفية (Child Foreground Service)
  static Future<bool> startForegroundService() async {
    try {
      final result = await _channel.invokeMethod<bool>('startForegroundService');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل تشغيل الخدمة الدائمة',
        platform: e.code,
      );
    }
  }

  /// إيقاف الخدمة الدائمة في الخلفية
  static Future<bool> stopForegroundService() async {
    try {
      final result = await _channel.invokeMethod<bool>('stopForegroundService');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل إيقاف الخدمة الدائمة',
        platform: e.code,
      );
    }
  }

  /// التحقق مما إذا كانت الخدمة الدائمة نشطة حالياً
  static Future<bool> isForegroundServiceRunning() async {
    try {
      final result = await _channel.invokeMethod<bool>('isForegroundServiceRunning');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformBridgeException(
        e.message ?? 'فشل التحقق من حالة تشغيل الخدمة الدائمة',
        platform: e.code,
      );
    }
  }
}
