# 🚀 دليل النشر والمطابقة لمتاجري Google Play و Apple App Store
## Smart Guardian — Production Deployment, Security & Store Compliance

---

### 1️⃣ متطلبات ومطابقة متجر Google Play Store

#### أ. إقرار سياسة خدمة سهولة الوصول (Accessibility Service Declaration):
* عند رفع التطبيق إلى Google Play Console، سيُطلب منك تقديم فيديو وإقرار يوضح سبب استخدام `AccessibilityService`:
  * **الفئة**: تطبيقات الرقابة الأبوية (Parental Control Apps).
  * **السبب المقبول لدى Google**: "The accessibility service is used exclusively to detect foreground applications, enforce parental restrictions, and lock blocked applications according to rules set by the parent."
  * **مراعاة الخصوصية**: تم ضبط `canRetrieveWindowContent="false"` بحيث لا يقرأ التطبيق نصوص أو شاشات المستخدم، وهو شرط إلزامي لاجتياز المراجعة.

#### ب. إقرار مسؤول الجهاز (Device Administration):
* تقديم إقرار بأن `DeviceAdminReceiver` يُستخدم حصرياً لمنع إلغاء التثبيت غير المصرح به من قبل الطفل وتطبيق القفل الفوري للشاشة بناء على طلب الوالد.

#### ج. إقرار الخدمة الدائمة (Foreground Service on Android 14+):
* تم تحديد `android:foregroundServiceType="specialUse"` مع السمة التوضيحية:
  `android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE="Parental control screen time protection and application monitoring"`

#### د. أوامر بناء نسخة الإنتاج لأندرويد:
```bash
# بناء حزمة أندرويد الرسمية (AAB) الموقعة
cd apps/child_app
flutter build appbundle --release

cd ../parent_app
flutter build appbundle --release
```

---

### 2️⃣ متطلبات ومطابقة متجر Apple App Store

#### أ. إذن استخدام Apple Family Controls Entitlement:
* تتطلب آبل تقديم طلب إلكتروني رسمي لتفعيل صلاحية `com.apple.developer.family-controls` عبر حساب المطور في موقع:  
  `https://developer.apple.com/contact/request/family-controls/`
* بعد الموافقة، تظهر الصلاحية في لوحة Certificates, Identifiers & Profiles.

#### ب. الامتثال لبنود فئة الأطفال (App Store Review Guidelines 1.3 & 5.1.1):
* لا يحتوي التطبيق على أي إعلانات مخصصة أو مكتبات تتبع خارجية.
* تشفير كافة الاتصالات وحفظ البيانات وفق أعلى معايير أمان الأطفال.

#### ج. أوامر بناء نسخة الإنتاج للآيفون (على جهاز الماك):
```bash
cd apps/child_app
flutter build ipa --release

cd ../parent_app
flutter build ipa --release
```

---

### 3️⃣ نشر قواعد الأمان وتطبيق الويب على Firebase

```bash
# 1. نشر قواعد الأمان لقاعدة البيانات
firebase deploy --only firestore:rules

# 2. بناء ونشر لوحة الإدارة الويب
cd apps/admin_portal
flutter build web --release
firebase deploy --only hosting
```
