import 'package:sg_domain/sg_domain.dart';

/// ============================================================================
/// 📌 نموذج بيانات الأمر (Command Model / DTO)
/// ----------------------------------------------------------------------------
/// يحول كائن الأمر من وإلى Map مناسبة لـ Cloud Firestore والإشعارات.
/// ============================================================================

class CommandModel extends CommandEntity {
  const CommandModel({
    required super.id,
    required super.childId,
    required super.deviceId,
    required super.action,
    super.payload,
    required super.status,
    required super.createdAt,
  });

  /// إنشاء كائن من خريطة بيانات Firestore أو FCM
  factory CommandModel.fromMap(Map<String, dynamic> map, String id) {
    return CommandModel(
      id: id,
      childId: map['childId'] as String? ?? '',
      deviceId: map['deviceId'] as String? ?? '',
      action: map['action'] as String? ?? '',
      payload: map['payload'] as Map<String, dynamic>?,
      status: CommandStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => CommandStatus.pending,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
    );
  }

  /// تحويل الكائن إلى خريطة مناسبة للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'deviceId': deviceId,
      'action': action,
      'payload': payload,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
