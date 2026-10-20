# 🍎 دليل الإعداد والتشغيل على جهاز الماك (MacBook iOS Setup Guide)
## Smart Guardian — Apple Family Controls & Screen Time Setup

> **ملاحظة هامة للمطور (وفق البند 6 من ميثاق المشروع)**:
> يتم تطوير الشيفرات البرمجية واختبارات الـ Monorepo على حاسوب الويندوز الرئيسي، بينما يُستخدم جهاز الماك لفتح مشروع Xcode وتوقيع الشهادات وتشغيل وبناء تطبيقات الآيفون (iOS Target).

---

### 1️⃣ الخطوة الأولى: سحب التحديثات وتثبيت التبعيات على الماك

افتح تطبيق **Terminal** على جهاز الماك ونفذ الأوامر التالية:

```bash
# 1. الانتقال لمجلد المشروع وسحب آخر التحديثات من GitHub
cd /path/to/smart_guardian
git pull origin main

# 2. تحديث وتثبيت حزم الـ Monorepo عبر Melos
melos bootstrap

# 3. تثبيت حزم CocoaPods لتطبيق الطفل
cd apps/child_app/ios
pod install

# 4. تثبيت حزم CocoaPods لتطبيق الأب
cd ../../parent_app/ios
pod install
```

---

### 2️⃣ الخطوة الثانية: فتح المشروع داخل بيئة Xcode

> ⚠️ **تنبيه هام جداً**: احرص دائماً على فتح ملف مساحة العمل `.xcworkspace` وليس ملف المشروع القديم `.xcodeproj`.

```bash
cd apps/child_app/ios
open Runner.xcworkspace
```

---

### 3️⃣ الخطوة الثالثة: ضبط التوقيع والصلاحيات (Signing & Capabilities)

1. في القائمة الجانبية اليسرى لـ Xcode، اضغط على المشروع الرئيسي **Runner**.
2. اختر Target اسمه **Runner**.
3. توجه إلى تبويب **Signing & Capabilities**:
   * حدد حساب المطور الخاص بك في خانة **Team** (Apple Developer Account).
   * تأكد من إعداد **Bundle Identifier** فريد (مثلاً `com.speed3d.smartguardian.child`).
4. اضغط على زر **`+ Capability`** في الأعلى وأضف الميزات التالية:
   * **Family Controls**: تفعيل صلاحية الرقابة الأبوية.
   * **App Groups**: أضف مجموعة باسم `group.com.smartguardian.childapp` لتمكين مشاركة الإعدادات بين التطبيق وملحق المراقبة.
   * **Background Modes**: فعّل خيار `Background fetch` و `Remote notifications`.

---

### 4️⃣ الخطوة الرابعة: إضافة ملحق مراقبة نشاط الجهاز (DeviceActivityMonitor Extension)

لتمكين نظام iOS من مراقبة النشاط في الخلفية وقفل التطبيقات تلقائياً عند انتهاء الوقت:

1. في شريط القوائم العلوي بـ Xcode، اختر: **File** > **New** > **Target...**
2. ابحث عن **Device Activity Monitor Extension** واضغط **Next**.
3. اكتب الاسم: `DeviceActivityMonitorExtension`.
4. اختر لغة البرمجة: **Swift**.
5. سيقوم Xcode بإنشاء الهدف، ثم استبدل ملفاته بالملفات المجهزة في المشروع:
   * انسخ الكود من: [`apps/child_app/ios/DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.swift`](file:///d:/Smart%20Guardian/apps/child_app/ios/DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.swift).
6. أضف نفس صلاحية **App Groups** (`group.com.smartguardian.childapp`) لهذا الـ Extension في تبويب **Signing & Capabilities**.

---

### 5️⃣ الخطوة الخامسة: التشغيل والاختبار على آيفون حقيقي أو محاكي (Simulator)

1. **على المحاكي (iOS Simulator)**:
   * اختر جهاز iPhone 15 أو 16 بنظام iOS 16+.
   * اضغط زر **Run (⌘ + R)**.
2. **على جهاز آيفون حقيقي (Physical Device - موصى به للرقابة الأبوية)**:
   * صل جهاز الآيفون بالماك عبر الكابل.
   * تأكد من تفعيل وضع المطور **Developer Mode** على الآيفون من: `Settings > Privacy & Security > Developer Mode`.
   * اختر جهازك واضغط **Run (⌘ + R)**.
   * عند فتح التطبيق، ستظهر نافذة تطلب إذن Apple Family Controls، اضغط **موافقة (Approve)**.

---

### 6️⃣ ملخص بنية ملفات iOS في المشروع

```text
apps/child_app/ios/
├── Runner/
│   ├── AppDelegate.swift             # تسجيل القناة ومحرك Flutter
│   ├── AppleNativeBridgeHandler.swift # معالج قنوات MethodChannel لنظام iOS
│   ├── FamilyControlsManager.swift    # مدير FamilyControls و ManagedSettings و DeviceActivity
│   ├── Info.plist                     # أذونات الرقابة الأبوية والموقع
│   └── Runner.entitlements            # صلاحية com.apple.developer.family-controls
└── DeviceActivityMonitorExtension/
    ├── DeviceActivityMonitorExtension.swift # ملحق مراقبة الخلفية وحظر التطبيقات عند انتهاء الوقت
    └── Info.plist                           # تكوين الملحق
```
