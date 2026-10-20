import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// ============================================================================
// 📌 حالة استخدام تسجيل الدخول (Sign In Use Case)
// ----------------------------------------------------------------------------
// تنفذ التحقق من بيانات الدخول لولي الأمر.
// ============================================================================

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }
}
