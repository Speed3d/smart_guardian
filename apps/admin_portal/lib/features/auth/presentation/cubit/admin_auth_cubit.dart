import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_auth_state.dart';

// ============================================================================
// 📌 إدارة مصادقة المشرفين (Admin Auth Cubit)
// ----------------------------------------------------------------------------
// يدير التحقق من أمان حسابات الإدارة والدعم الفني.
// ============================================================================

class AdminAuthCubit extends Cubit<AdminAuthState> {
  AdminAuthCubit() : super(const AdminAuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AdminAuthStatus.authenticating));
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('@') && password.length >= 6) {
      emit(state.copyWith(
        status: AdminAuthStatus.authenticated,
        adminEmail: email,
      ));
    } else {
      emit(state.copyWith(
        status: AdminAuthStatus.failure,
        errorMessage: 'بيانات الدخول غير صحيحة أو الصلاحيات غير كافية.',
      ));
    }
  }

  void logout() {
    emit(const AdminAuthState(
      status: AdminAuthStatus.unauthenticated,
      adminEmail: null,
    ));
  }
}
