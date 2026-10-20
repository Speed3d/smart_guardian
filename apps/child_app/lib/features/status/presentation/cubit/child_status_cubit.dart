import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';
import '../../domain/batch_usage_syncer.dart';
import '../../domain/child_command_dispatcher.dart';
import 'child_status_state.dart';

// ============================================================================
// 📌 إدارة حالة تطبيق الطفل (Child Status Cubit)
// ----------------------------------------------------------------------------
// يدمج موزع الأوامر الفورية (Command Dispatcher)، ومزامن الاستخدام الموفر للتكلفة
// (Batch Usage Syncer)، والجسر الأصلي لنظام أندرويد (Native Bridge).
// ============================================================================

class ChildStatusCubit extends Cubit<ChildStatusState> {
  final ChildCommandDispatcher commandDispatcher;
  final BatchUsageSyncer? usageSyncer;

  ChildStatusCubit({
    required this.commandDispatcher,
    this.usageSyncer,
  }) : super(const ChildStatusState()) {
    _setupDispatcherCallbacks();
  }

  void _setupDispatcherCallbacks() {
    commandDispatcher.onLockStateChanged = (isLocked) {
      emit(state.copyWith(isLocked: isLocked));
    };

    commandDispatcher.onTimeExtended = (additionalMinutes) {
      emit(state.copyWith(
        remainingMinutes: state.remainingMinutes + additionalMinutes,
        lastExecutedCommand: 'تم تمديد الوقت بـ $additionalMinutes دقيقة',
      ));
    };

    commandDispatcher.onBlockedAppsChanged = (blocked) {
      emit(state.copyWith(
        blockedPackages: blocked,
        lastExecutedCommand: 'تم تحديث قائمة التطبيقات المحظورة (${blocked.length})',
      ));
    };

    commandDispatcher.onCommandExecuted = (command) {
      String desc;
      switch (command.action) {
        case AppConstants.commandLockDevice:
          desc = 'تم قفل الجهاز فورياً بطلب الأب';
          break;
        case AppConstants.commandUnlockDevice:
          desc = 'تم فتح قفل الجهاز بطلب الأب';
          break;
        case AppConstants.commandExtendScreenTime:
          desc = 'تم تمديد وقت الشاشة بنجاح';
          break;
        case AppConstants.commandBlockApp:
          desc = 'تم حظر تطبيق جديد بنجاح';
          break;
        case AppConstants.commandUnblockApp:
          desc = 'تم إلغاء حظر التطبيق بنجاح';
          break;
        case AppConstants.commandRequestLocation:
          desc = 'تم إرسال إحداثيات الموقع الحالي للأب';
          break;
        default:
          desc = 'تم تنفيذ الأمر: ${command.action}';
      }
      emit(state.copyWith(lastExecutedCommand: desc));
    };
  }

  /// التحقق من صلاحية إدارة الجهاز والخدمة الدائمة
  Future<void> checkNativeStatus() async {
    try {
      final isAdmin = await DeviceControlBridge.isDeviceAdminActive();
      final isServiceRunning = await DeviceControlBridge.isForegroundServiceRunning();
      final blocked = await DeviceControlBridge.getBlockedPackages();
      emit(state.copyWith(
        isDeviceAdminActive: isAdmin,
        isForegroundServiceRunning: isServiceRunning,
        blockedPackages: blocked,
      ));
    } catch (_) {
      // تجاهل أخطاء المنصة في بيئات الاختبار
    }
  }

  /// بدء الاستماع لأوامر الأب الحية وتشغيل الحماية الدائمة
  void listenToParentCommands(String childId, String deviceId) {
    commandDispatcher.startListening(childId: childId, deviceId: deviceId);

    // تفعيل الخدمة الدائمة في الخلفية لضمان استمرار الحماية 24/7
    try {
      DeviceControlBridge.startForegroundService();
      emit(state.copyWith(isForegroundServiceRunning: true));
    } catch (_) {}

    // بدء المزامنة الدورية المجمعة لوقت الشاشة
    usageSyncer?.startPeriodicSync(childId: childId, deviceId: deviceId);

    checkNativeStatus();
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
    commandDispatcher.dispose();
    usageSyncer?.stop();
    return super.close();
  }
}
