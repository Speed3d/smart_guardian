import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 نموذج بيانات كود الربط (Pairing Code Model / DTO)
// ----------------------------------------------------------------------------
// يحول وثيقة كود الربط في Cloud Firestore من وإلى PairingCodeEntity.
// ============================================================================

class PairingCodeModel extends PairingCodeEntity {
  const PairingCodeModel({
    required super.id,
    required super.code,
    required super.parentId,
    required super.childId,
    required super.expiresAt,
    super.isUsed,
  });

  factory PairingCodeModel.fromMap(Map<String, dynamic> map, String id) {
    return PairingCodeModel(
      id: id,
      code: map['code'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
      childId: map['childId'] as String? ?? '',
      expiresAt: map['expiresAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] as int)
          : DateTime.now().add(const Duration(minutes: 10)),
      isUsed: map['isUsed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'parentId': parentId,
      'childId': childId,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'isUsed': isUsed,
    };
  }
}
