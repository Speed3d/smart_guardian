import Flutter
import UIKit

// ============================================================================
// 📌 نقطة انطلاق تطبيق الطفل لنظام iOS (AppDelegate) - Smart Guardian
// ----------------------------------------------------------------------------
// تسجل ملحقات Flutter وقناة الجسر الأصلية AppleNativeBridgeHandler
// للربط بين محرك Flutter وأطر عمل الرقابة الأبوية FamilyControls و ManagedSettings.
// ============================================================================

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as? FlutterViewController
    if let controller = controller {
      let registrar = controller.registrar(forPlugin: "AppleNativeBridgeHandler")
      if let registrar = registrar {
        AppleNativeBridgeHandler.register(with: registrar)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
