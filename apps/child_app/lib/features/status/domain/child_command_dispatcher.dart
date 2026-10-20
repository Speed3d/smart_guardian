import 'dart:async';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';

/// ============================================================================
/// 📌 موزع ومنفذ الأوامر الفورية لتطبيق الطفل (Child Command Dispatcher)
/// ----------------------------------------------------------------------------
/// يستمع للأوامر القادمة من Firestore/FCM ويوجهها للجسر البرمجي الأصلي (Native Bridge):
/// 1. LOCK_DEVICE: قفل الشاشة فوراً
/// 2. UNLOCK_DEVICE: تنشيط وفك قفل الشاشة
/// 3. EXTEND_SCREEN_TIME: تمديد وقت الشاشة
/// 4. BLOCK_APP: حظر تطبيق معين وتحديث خدمة سهولة الوصول
/// 5. UNBLOCK_APP: إلغاء حظر تطبيق معين
/// 6. REQUEST_LOCATION: طلب الموقع الفوري
/// ============================================================================

typedef OnLockStateChanged = void Function(bool isLocked);
typedef OnTimeExtended = void Function(int additionalMinutes);
typedef OnBlockedAppsChanged = void Function(List<String> blockedPackages);
typedef OnCommandExecuted = void Function(CommandEntity command);

class ChildCommandDispatcher {
  final ListenToChildCommandsUseCase listenToCommandsUseCase;
  final AcknowledgeCommandUseCase acknowledgeCommandUseCase;

  StreamSubscription<CommandEntity>? _subscription;

  OnLockStateChanged? onLockStateChanged;
  OnTimeExtended? onTimeExtended;
  OnBlockedAppsChanged? onBlockedAppsChanged;
  OnCommandExecuted? onCommandExecuted;

  ChildCommandDispatcher({
    required this.listenToCommandsUseCase,
    required this.acknowledgeCommandUseCase,
  });

  /// بدء الاستماع للأوامر الفورية وتوزيعها
  void startListening({
    required String childId,
    required String deviceId,
  }) {
    _subscription?.cancel();
    _subscription = listenToCommandsUseCase
        .execute(childId, deviceId)
        .listen(_handleIncomingCommand);
  }

  /// معالجة وتوزيع كل أمر قادم بحسب نوعه
  Future<void> _handleIncomingCommand(CommandEntity command) async {
    try {
      switch (command.action) {
        // --- 1. قفل شاشة الهاتف فوراً ---
        case AppConstants.commandLockDevice:
          await DeviceControlBridge.lockDevice();
          onLockStateChanged?.call(true);
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        // --- 2. إلغاء قفل شاشة الهاتف ---
        case AppConstants.commandUnlockDevice:
          await DeviceControlBridge.unlockDevice();
          onLockStateChanged?.call(false);
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        // --- 3. تمديد وقت الشاشة المسموح ---
        case AppConstants.commandExtendScreenTime:
          final minutes =
              (command.payload?['extraMinutes'] as num?)?.toInt() ?? 15;
          onTimeExtended?.call(minutes);
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        // --- 4. حظر تطبيق محدد ---
        case AppConstants.commandBlockApp:
          final pkg = command.payload?['packageName'] as String?;
          if (pkg != null && pkg.isNotEmpty) {
            final current = await DeviceControlBridge.getBlockedPackages();
            if (!current.contains(pkg)) {
              final updated = List<String>.from(current)..add(pkg);
              await DeviceControlBridge.setBlockedPackages(updated);
              onBlockedAppsChanged?.call(updated);
            }
          }
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        // --- 5. إلغاء حظر تطبيق محدد ---
        case AppConstants.commandUnblockApp:
          final pkg = command.payload?['packageName'] as String?;
          if (pkg != null && pkg.isNotEmpty) {
            final current = await DeviceControlBridge.getBlockedPackages();
            final updated = List<String>.from(current)..remove(pkg);
            await DeviceControlBridge.setBlockedPackages(updated);
            onBlockedAppsChanged?.call(updated);
          }
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        // --- 6. طلب الموقع الفوري ---
        case AppConstants.commandRequestLocation:
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.executed,
          );
          break;

        default:
          await acknowledgeCommandUseCase.execute(
            commandId: command.id,
            status: CommandStatus.failed,
          );
          break;
      }

      onCommandExecuted?.call(command);
    } catch (_) {
      await acknowledgeCommandUseCase.execute(
        commandId: command.id,
        status: CommandStatus.failed,
      );
    }
  }

  /// إيقاف الاستماع وإلغاء الاشتراك
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
