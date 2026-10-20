import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 حالات مصادقة لوحة الإدارة (Admin Auth State)
// ----------------------------------------------------------------------------
// يمثل حالة تسجيل دخول المشرف والدعم الفني وصلاحيات الإدارة.
// ============================================================================

enum AdminAuthStatus { unauthenticated, authenticating, authenticated, failure }

class AdminAuthState extends Equatable {
  final AdminAuthStatus status;
  final String? adminEmail;
  final String? errorMessage;

  const AdminAuthState({
    this.status = AdminAuthStatus.authenticated, // افتراضياً مسجل لتسهيل الدخول التجريبي
    this.adminEmail = 'admin@smartguardian.app',
    this.errorMessage,
  });

  AdminAuthState copyWith({
    AdminAuthStatus? status,
    String? adminEmail,
    String? errorMessage,
  }) {
    return AdminAuthState(
      status: status ?? this.status,
      adminEmail: adminEmail ?? this.adminEmail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, adminEmail, errorMessage];
}
