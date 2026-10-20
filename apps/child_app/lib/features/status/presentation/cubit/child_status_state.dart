import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 حالات شاشة الطفل (Child Status States)
// ----------------------------------------------------------------------------
// تمثل حالة تطبيق الطفل (الوقت المتبقي، حالة القفل، وإرسال الـ SOS).
// ============================================================================

class ChildStatusState extends Equatable {
  final int remainingMinutes;
  final bool isLocked;
  final bool isSendingSos;
  final bool isDeviceAdminActive;
  final String? alertMessage;

  const ChildStatusState({
    this.remainingMinutes = 90,
    this.isLocked = false,
    this.isSendingSos = false,
    this.isDeviceAdminActive = false,
    this.alertMessage,
  });

  ChildStatusState copyWith({
    int? remainingMinutes,
    bool? isLocked,
    bool? isSendingSos,
    bool? isDeviceAdminActive,
    String? alertMessage,
  }) {
    return ChildStatusState(
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      isLocked: isLocked ?? this.isLocked,
      isSendingSos: isSendingSos ?? this.isSendingSos,
      isDeviceAdminActive: isDeviceAdminActive ?? this.isDeviceAdminActive,
      alertMessage: alertMessage,
    );
  }

  @override
  List<Object?> get props => [
        remainingMinutes,
        isLocked,
        isSendingSos,
        isDeviceAdminActive,
        alertMessage,
      ];
}
