// ============================================================================
// 📌 تصنيفات الفشل والأخطاء المنطقية (Failures)
// ----------------------------------------------------------------------------
// هذا الملف يحدد الأخطاء المنطقية في طبقة Domain، بحيث تعود دوال الـ Use Cases
// بنتيجة إما النجاح أو كائن من نوع [Failure] لتسهيل معالجة الأخطاء وعرضها للمستخدم.
// ============================================================================

abstract class Failure {
  /// رسالة الخطأ الواضحة الموجهة لواجهة المستخدم
  final String message;

  /// رمز الخطأ البرمجي للتحقق والتتبع
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// فشل ناتج عن مشاكل الاتصال بالإنترنت أو الخادم
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// فشل ناتج عن خطأ في التخزين المحلي (Hive أو SecureStorage)
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// فشل ناتج عن رفض الصلاحيات (الموقع، إدارة الجهاز، أو سهولة الوصول)
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// فشل ناتج عن خطأ في عملية مصادقة المستخدم (تسجيل الدخول / كلمة المرور)
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// فشل ناتج عن عدم صلاحية كود الربط أو انتهاء وقته
class PairingFailure extends Failure {
  const PairingFailure(super.message, {super.code});
}

/// فشل ناتج عن عدم توفر الخدمة على المنصة الحالية (مثل ميزة خاصة بأندرويد فقط)
class PlatformNotSupportedFailure extends Failure {
  const PlatformNotSupportedFailure(super.message, {super.code});
}
