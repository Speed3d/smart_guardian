// ============================================================================
// 📌 ثوابت النظام العامة - Smart Guardian
// ----------------------------------------------------------------------------
// هذا الملف يحتوي على المعرّفات والثوابت المشتركة بين تطبيقي الأب والطفل،
// مثل أسماء المجموعات في Firestore، وأوامر التحكم، ومفاتيح الإشعارات.
// ============================================================================

class AppConstants {
  // منع إنشاء كائن من هذا الكلاس لأنه كلاس ثابت
  const AppConstants._();

  /// اسم التطبيق العام
  static const String appName = 'Smart Guardian';

  /// إصدار النظام البرمجي
  static const String appVersion = '2.0.0';

  // ---------------------------------------------------------------------------
  // أسماء مجموعات قاعدة بيانات Cloud Firestore (Collections)
  // ---------------------------------------------------------------------------
  static const String usersCollection = 'users';
  static const String familiesCollection = 'families';
  static const String childrenCollection = 'children';
  static const String devicesCollection = 'devices';
  static const String pairingCodesCollection = 'pairing_codes';
  static const String commandsCollection = 'commands';
  static const String usageLogsCollection = 'usage_logs';
  static const String locationsCollection = 'locations';
  static const String notificationsCollection = 'notifications';
  static const String subscriptionsCollection = 'subscriptions';
  static const String reportsCollection = 'reports';

  // ---------------------------------------------------------------------------
  // أوامر التحكم عن بعد (Commands)
  // ---------------------------------------------------------------------------
  /// أمر قفل جهاز الطفل فوراً
  static const String commandLockDevice = 'LOCK_DEVICE';

  /// أمر فتح قفل جهاز الطفل
  static const String commandUnlockDevice = 'UNLOCK_DEVICE';

  /// أمر تمديد وقت الشاشة المسموح
  static const String commandExtendScreenTime = 'EXTEND_SCREEN_TIME';

  /// أمر حظر تطبيق معين
  static const String commandBlockApp = 'BLOCK_APP';

  /// أمر إلغاء حظر تطبيق معين
  static const String commandUnblockApp = 'UNBLOCK_APP';

  /// أمر طلب تحديث الموقع الجغرافي الفوري
  static const String commandRequestLocation = 'REQUEST_LOCATION';

  // ---------------------------------------------------------------------------
  // معرّفات قنوات الاتصال الأصلية (Platform Channels)
  // ---------------------------------------------------------------------------
  static const String methodChannelName = 'com.smartguardian/native_bridge';
  static const String eventChannelLocation = 'com.smartguardian/location_stream';
  static const String eventChannelAppUsage = 'com.smartguardian/usage_stream';

  // ---------------------------------------------------------------------------
  // مدد الصلاحيات والتوقيتات الافتراضية
  // ---------------------------------------------------------------------------
  /// مدة صلاحية كود ربط جهاز الطفل (بالدقائق)
  static const int pairingCodeValidityMinutes = 10;

  /// طول كود الربط الرقمي
  static const int pairingCodeLength = 6;

  /// الفاصل الزمني لإرسال الموقع المجمع (بالدقائق) لتقليل التكلفة
  static const int locationBatchIntervalMinutes = 60;
}
