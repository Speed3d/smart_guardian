import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

// ============================================================================
// 📌 مدير خدمات أبل للرقابة الأبوية (Apple Family Controls Manager)
// ----------------------------------------------------------------------------
// يدير أطر العمل الرسمية من شركة Apple لنظام iOS 15.0+ و iOS 16.0+:
// 1. FamilyControls: الحصول على تصريح الأب (Parental Authorization).
// 2. ManagedSettings: قفل التطبيقات وتطبيق دروع الحماية (App Shielding).
// 3. DeviceActivity: مراقبة وجدولة وقت الشاشة في الخلفية.
// ============================================================================

@available(iOS 15.0, *)
class FamilyControlsManager {
    static let shared = FamilyControlsManager()

    // مخزن إعدادات الحظر والتقييد من أبل
    private let managedSettingsStore = ManagedSettingsStore()
    
    // مركز إدارة ومراقبة نشاط الجهاز
    private let deviceActivityCenter = DeviceActivityCenter()

    // معرف جدول نشاط الطفل الافتراضي
    private let activityName = DeviceActivityName("com.smartguardian.daily_schedule")

    private init() {}

    // ------------------------------------------------------------------------
    // 1. صلاحيات الرقابة الأبوية (Family Controls Authorization)
    // ------------------------------------------------------------------------

    /// التحقق مما إذا كان تصريح الرقابة الأبوية ممنوحاً من ولي الأمر
    func isAuthorized() -> Bool {
        return AuthorizationCenter.shared.authorizationStatus == .approved
    }

    /// طلب تصريح الرقابة الأبوية لجهاز الطفل (يتطلب تسجيل حساب Apple ID للطفل)
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .child)
                let isApproved = self.isAuthorized()
                print("Smart Guardian: FamilyControls authorization result = \(isApproved)")
                DispatchQueue.main.async {
                    completion(isApproved)
                }
            } catch {
                print("Smart Guardian: FamilyControls authorization error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    // ------------------------------------------------------------------------
    // 2. قفل وفتح تطبيقات الآيفون (Managed Settings Shielding)
    // ------------------------------------------------------------------------

    /// قفل كافة التطبيقات على جهاز الآيفون فوراً استجابة لأمر ولي الأمر
    func lockDevice() -> Bool {
        guard isAuthorized() else {
            print("Smart Guardian: Cannot lock - FamilyControls not authorized.")
            return false
        }
        
        // تفعيل درع الحظر على كافة فئات وتصنيفات التطبيقات
        managedSettingsStore.shield.applicationCategories = .all()
        print("Smart Guardian: iOS Device Shield applied to all application categories.")
        return true
    }

    /// فك القفل وإلغاء حظر التطبيقات
    func unlockDevice() -> Bool {
        // إزالة دروع الحظر واستعادة الوضع الطبيعي
        managedSettingsStore.shield.applicationCategories = nil
        managedSettingsStore.shield.applications = nil
        print("Smart Guardian: iOS Device Shield removed successfully.")
        return true
    }

    // ------------------------------------------------------------------------
    // 3. جدولة ومراقبة وقت الشاشة (Device Activity Schedule)
    // ------------------------------------------------------------------------

    /// بدء مراقبة جدول نشاط الجهاز لوقت الشاشة اليومي
    func startMonitoring(limitMinutes: Int) -> Bool {
        guard isAuthorized() else { return false }

        // إعداد جدول يومي من الصباح وحتى المساء
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        do {
            try deviceActivityCenter.startMonitoring(activityName, during: schedule)
            print("Smart Guardian: DeviceActivityCenter monitoring started successfully.")
            return true
        } catch {
            print("Smart Guardian: Failed to start DeviceActivity monitoring: \(error)")
            return false
        }
    }

    /// إيقاف مراقبة جدول نشاط الجهاز
    func stopMonitoring() {
        deviceActivityCenter.stopMonitoring([activityName])
        print("Smart Guardian: DeviceActivityCenter monitoring stopped.")
    }
}
