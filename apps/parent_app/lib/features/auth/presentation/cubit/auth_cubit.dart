import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'auth_state.dart';

// ============================================================================
// 📌 إدارة مصادقة ولي الأمر (Auth Cubit)
// ----------------------------------------------------------------------------
// يدير تسجيل الدخول والخروج والتحقق من حالة المستخدم مع Firebase Auth.
// ============================================================================

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final SignInUseCase signInUseCase;
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthCubit({
    required this.authRepository,
    required this.signInUseCase,
  }) : super(const AuthState()) {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      }
    });
  }

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await signInUseCase.execute(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await authRepository.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
