import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 نموذج بيانات جهاز الطفل (Device Model / DTO)
// ----------------------------------------------------------------------------
// يحول بيانات هاتف الطفل من وإلى صيغة وثيقة Cloud Firestore.
// ============================================================================

class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.childId,
    required super.parentId,
    required super.model,
    required super.osVersion,
    super.isPaired,
    super.batteryLevel,
    required super.lastSeenAt,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map, String id) {
    return DeviceModel(
      id: id,
      childId: map['childId'] as String? ?? '',
      parentId: map['parentId'] as String? ?? '',
      model: map['model'] as String? ?? 'Unknown Device',
      osVersion: map['osVersion'] as String? ?? '',
      isPaired: map['isPaired'] as bool? ?? true,
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? 100,
      lastSeenAt: map['lastSeenAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeenAt'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'parentId': parentId,
      'model': model,
      'osVersion': osVersion,
      'isPaired': isPaired,
      'batteryLevel': batteryLevel,
      'lastSeenAt': lastSeenAt.millisecondsSinceEpoch,
    };
  }
}
