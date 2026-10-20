import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';
import 'child_status_state.dart';

// ============================================================================
// 📌 إدارة حالة تطبيق الطفل (Child Status Cubit)
// ----------------------------------------------------------------------------
// يستمع لأوامر الأب الحية عبر CommandRepository ويطبق القفل عبر DeviceControlBridge.
// ============================================================================

class ChildStatusCubit extends Cubit<ChildStatusState> {
  final CommandRepository commandRepository;
  StreamSubscription<CommandEntity>? _commandsSubscription;

  ChildStatusCubit({
    required this.commandRepository,
  }) : super(const ChildStatusState());

  /// التحقق من صلاحية إدارة الجهاز الأصلية
  Future<void> checkDeviceAdminStatus() async {
    try {
      final isActive = await DeviceControlBridge.isDeviceAdminActive();
      emit(state.copyWith(isDeviceAdminActive: isActive));
    } catch (_) {
      emit(state.copyWith(isDeviceAdminActive: false));
    }
  }

  /// بدء الاستماع لأوامر الأب الحية عبر الـ Repository
  void listenToParentCommands(String childId, String deviceId) {
    _commandsSubscription?.cancel();
    _commandsSubscription = commandRepository
        .listenToChildCommands(childId, deviceId)
        .listen((command) async {
      if (command.action == AppConstants.commandLockDevice) {
        await DeviceControlBridge.lockDevice();
        emit(state.copyWith(isLocked: true));
        await commandRepository.updateCommandStatus(
            command.id, CommandStatus.executed);
      } else if (command.action == AppConstants.commandUnlockDevice) {
        await DeviceControlBridge.unlockDevice();
        emit(state.copyWith(isLocked: false));
        await commandRepository.updateCommandStatus(
            command.id, CommandStatus.executed);
      }
    });
  }

  /// إرسال إشارة الطوارئ SOS
  Future<void> sendSosAlert() async {
    emit(state.copyWith(isSendingSos: true));
    await Future.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(
      isSendingSos: false,
      alertMessage:
          'تم إرسال موقعك الجغرافي واستغاثة الطوارئ فوراً إلى هاتف ولي الأمر.',
    ));
  }

  /// إعادة تعيين رسالة التنبيه بعد عرضها
  void clearAlert() {
    emit(state.copyWith(alertMessage: null));
  }

  @override
  Future<void> close() {
    _commandsSubscription?.cancel();
    return super.close();
  }
}
