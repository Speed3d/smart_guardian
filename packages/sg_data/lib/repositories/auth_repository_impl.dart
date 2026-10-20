import 'package:sg_domain/sg_domain.dart';
import '../datasources/remote/firebase_auth_datasource.dart';

// ============================================================================
// 📌 تطبيق مستودع المصادقة (Auth Repository Implementation)
// ----------------------------------------------------------------------------
// يربط واجهة AuthRepository بمصدر بيانات Firebase Authentication.
// ============================================================================

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _dataSource.registerWithEmailAndPassword(
        email, password, displayName);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _dataSource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _dataSource.authStateChanges;
  }
}
