import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 كيان المستخدم / ولي الأمر (User Entity)
// ----------------------------------------------------------------------------
// يمثل بيانات حساب ولي الأمر الأساسية في طبقة الـ Domain المجردة.
// ============================================================================

class UserEntity extends Equatable {
  /// المعرف الفريد للمستخدم في Firebase Auth
  final String id;

  /// البريد الإلكتروني
  final String email;

  /// اسم ولي الأمر المعروض
  final String? displayName;

  /// الصورة الشخصية إن وجدت
  final String? photoUrl;

  /// تاريخ إنشاء الحساب
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, createdAt];
}
