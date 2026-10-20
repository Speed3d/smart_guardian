import '../entities/user_entity.dart';

// ============================================================================
// 📌 واجهة مستودع المصادقة (Auth Repository Interface)
// ----------------------------------------------------------------------------
// عقد تجريدي لعمليات تسجيل الدخول والخروج والتحقق من المستخدم الحالي.
// ============================================================================

abstract class AuthRepository {
  /// تسجيل الدخول بواسطة البريد الإلكتروني وكلمة المرور
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// إنشاء حساب جديد لولي الأمر
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// تسجيل الخروج
  Future<void> signOut();

  /// جلب المستخدم الحالي إن وجد
  Future<UserEntity?> getCurrentUser();

  /// تدفق حالة المستخدم اللحظية (Stream)
  Stream<UserEntity?> get authStateChanges;
}
