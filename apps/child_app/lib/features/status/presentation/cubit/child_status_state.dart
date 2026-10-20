import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 حالات شاشة الطفل (Child Status States)
// ----------------------------------------------------------------------------
// تمثل حالة تطبيق الطفل (الوقت المتبقي، حالة القفل، التطبيقات المحظورة، والخدمة الدائمة).
// ============================================================================

class ChildStatusState extends Equatable {
  final int remainingMinutes;
  final bool isLocked;
  final bool isSendingSos;
  final bool isDeviceAdminActive;
  final bool isForegroundServiceRunning;
  final List<String> blockedPackages;
  final String? lastExecutedCommand;
  final String? alertMessage;

  const ChildStatusState({
    this.remainingMinutes = 90,
    this.isLocked = false,
    this.isSendingSos = false,
    this.isDeviceAdminActive = false,
    this.isForegroundServiceRunning = false,
    this.blockedPackages = const [],
    this.lastExecutedCommand,
    this.alertMessage,
  });

  ChildStatusState copyWith({
    int? remainingMinutes,
    bool? isLocked,
    bool? isSendingSos,
    bool? isDeviceAdminActive,
    bool? isForegroundServiceRunning,
    List<String>? blockedPackages,
    String? lastExecutedCommand,
    String? alertMessage,
  }) {
    return ChildStatusState(
      remainingMinutes: remainingMinutes ?? this.remainingMinutes,
      isLocked: isLocked ?? this.isLocked,
      isSendingSos: isSendingSos ?? this.isSendingSos,
      isDeviceAdminActive: isDeviceAdminActive ?? this.isDeviceAdminActive,
      isForegroundServiceRunning:
          isForegroundServiceRunning ?? this.isForegroundServiceRunning,
      blockedPackages: blockedPackages ?? this.blockedPackages,
      lastExecutedCommand: lastExecutedCommand ?? this.lastExecutedCommand,
      alertMessage: alertMessage,
    );
  }

  @override
  List<Object?> get props => [
        remainingMinutes,
        isLocked,
        isSendingSos,
        isDeviceAdminActive,
        isForegroundServiceRunning,
        blockedPackages,
        lastExecutedCommand,
        alertMessage,
      ];
}
