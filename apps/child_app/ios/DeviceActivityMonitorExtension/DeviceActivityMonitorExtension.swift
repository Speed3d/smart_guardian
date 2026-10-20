import DeviceActivity
import ManagedSettings

// ============================================================================
// 📌 ملحق مراقبة نشاط الجهاز في الخلفية (Device Activity Monitor Extension)
// ----------------------------------------------------------------------------
// هذا الملحق (App Extension) يعمل بشكل مستقل في خلفية نظام iOS لمراقبة
// جدول استخدام الطفل وتطبيق دروع الحظر تلقائياً عند استنفاذ وقت الشاشة.
// ============================================================================

@available(iOS 15.0, *)
class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    private let store = ManagedSettingsStore()

    /// يتم استدعاؤها عند بدء الفترة الزمنية المحددة للجدول اليومي
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("Smart Guardian Extension: Interval started for activity = \(activity.rawValue)")
    }

    /// يتم استدعاؤها عند انتهاء الفترة الزمنية للجدول اليومي
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("Smart Guardian Extension: Interval ended for activity = \(activity.rawValue)")
        
        // إزالة دروع الحظر تلقائياً عند انتهاء وقت التقييد
        store.shield.applicationCategories = nil
        store.shield.applications = nil
    }

    /// يتم استدعاؤها عندما يستنفد الطفل الحد الأقصى المسموح لوقت الشاشة
    override func eventDidReachThreshold(for event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(for: event, activity: activity)
        print("Smart Guardian Extension: Screen time threshold reached! Locking applications...")

        // قفل كافة التطبيقات فوراً لمنع الطفل من الاستمرار
        store.shield.applicationCategories = .all()
    }

    /// يتم استدعاؤها كتحذير مبكر قبل انتهاء الفترة المحددة بدقائق
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        print("Smart Guardian Extension: Interval will end warning received.")
    }
}
