import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 نموذج بيانات المستخدم (User Model / DTO)
// ----------------------------------------------------------------------------
// يحول كائن مستخدم Firebase Auth و Firestore إلى كيان UserEntity في الـ Domain.
// ============================================================================

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    required super.createdAt,
  });

  /// إنشاء كائن من مستخدم Firebase Auth
  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// إنشاء كائن من خريطة بيانات Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
    );
  }

  /// تحويل إلى خريطة Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
