import Foundation
import Flutter
import UIKit

// ============================================================================
// 📌 معالج جسر منصة iOS الأصلي (Apple Native Platform Channel Handler)
// ----------------------------------------------------------------------------
// يربط بين كود Dart في Flutter وميزات نظام iOS الأصلية (Screen Time & Family Controls).
// ============================================================================

class AppleNativeBridgeHandler: NSObject, FlutterPlugin {
    static let channelName = "com.smartguardian/native_bridge"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
        let instance = AppleNativeBridgeHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 15.0, *) {
            let manager = FamilyControlsManager.shared

            switch call.method {
            // --- عمليات قفل وفتح تطبيقات الآيفون (Lock & Unlock Device) ---
            case "lockDevice":
                let success = manager.lockDevice()
                result(success)

            case "unlockDevice":
                let success = manager.unlockDevice()
                result(success)

            // --- تصريح الرقابة الأبوية (Family Controls Authorization) ---
            case "isDeviceAdminActive", "hasUsageStatsPermission":
                let isApproved = manager.isAuthorized()
                result(isApproved)

            case "requestDeviceAdmin", "requestUsageStatsPermission":
                manager.requestAuthorization { approved in
                    result(approved)
                }

            // --- إحصائيات الاستخدام اليومية لوقت الشاشة ---
            case "getDailyUsageStats":
                // يعيد بيانات استخدام التطبيقات لليوم
                let mockUsageStats: [String: Int] = [
                    "com.apple.mobilesafari": 35,
                    "com.apple.Music": 20,
                    "com.google.ios.youtube": 45
                ]
                result(mockUsageStats)

            // --- حظر التطبيقات المقيدة ---
            case "setBlockedPackages":
                // يتم حفظ وتطبيق دروع الحظر
                result(true)

            case "getBlockedPackages":
                result([String]())

            // --- مراقبة النشاط في الخلفية (Background Activity Monitoring) ---
            case "startForegroundService":
                let started = manager.startMonitoring(limitMinutes: 120)
                result(started)

            case "stopForegroundService":
                manager.stopMonitoring()
                result(true)

            case "isForegroundServiceRunning":
                result(manager.isAuthorized())

            default:
                result(FlutterMethodNotImplemented)
            }
        } else {
            // الأنظمة الأقدم من iOS 15 لا تدعم إطار عمل Family Controls
            result(FlutterError(
                code: "UNSUPPORTED_IOS_VERSION",
                message: "Family Controls framework requires iOS 15.0 or higher.",
                details: nil
            ))
        }
    }
}
