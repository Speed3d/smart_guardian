import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'command_state.dart';

// ============================================================================
// 📌 إدارة أوامر التحكم عن بعد لتطبيق الأب (Command Cubit)
// ----------------------------------------------------------------------------
// يدير إرسال كافة أوامر الرقابة الأبوية ومتابعة حالة تنفيذها الحية (FCM & Real-time Commands).
// ============================================================================

class CommandCubit extends Cubit<CommandState> {
  final LockDeviceUseCase lockDeviceUseCase;
  final UnlockDeviceUseCase unlockDeviceUseCase;
  final ExtendScreenTimeUseCase extendScreenTimeUseCase;
  final ManageAppRestrictionUseCase manageAppRestrictionUseCase;
  final RequestLocationUseCase requestLocationUseCase;
  final CommandRepository commandRepository;

  StreamSubscription<List<CommandEntity>>? _commandsSubscription;

  CommandCubit({
    required this.lockDeviceUseCase,
    required this.unlockDeviceUseCase,
    required this.extendScreenTimeUseCase,
    required this.manageAppRestrictionUseCase,
    required this.requestLocationUseCase,
    required this.commandRepository,
  }) : super(const CommandState());

  /// بدء تتبع سجل الأوامر الحية الخاصة بالطفل
  void listenToRecentCommands(String childId) {
    _commandsSubscription?.cancel();
    _commandsSubscription = commandRepository
        .listenToRecentCommands(childId)
        .listen((commands) {
      emit(state.copyWith(recentCommands: commands));
    });
  }

  /// قفل جهاز الطفل فوراً
  Future<void> lockDevice({
    required String childId,
    required String deviceId,
  }) async {
    emit(state.copyWith(isSending: true));
    try {
      await lockDeviceUseCase.execute(childId: childId, deviceId: deviceId);
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم إرسال أمر قفل الجهاز بنجاح 🔒',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل إرسال أمر القفل: ${e.toString()}',
      ));
    }
  }

  /// فتح قفل جهاز الطفل
  Future<void> unlockDevice({
    required String childId,
    required String deviceId,
  }) async {
    emit(state.copyWith(isSending: true));
    try {
      await unlockDeviceUseCase.execute(childId: childId, deviceId: deviceId);
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم إرسال أمر إلغاء قفل الجهاز بنجاح 🔓',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل إرسال أمر إلغاء القفل: ${e.toString()}',
      ));
    }
  }

  /// تمديد وقت الشاشة
  Future<void> extendScreenTime({
    required String childId,
    required String deviceId,
    required int additionalMinutes,
  }) async {
    emit(state.copyWith(isSending: true));
    try {
      await extendScreenTimeUseCase.execute(
        childId: childId,
        deviceId: deviceId,
        additionalMinutes: additionalMinutes,
      );
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم إرسال أمر تمديد الوقت بـ $additionalMinutes دقيقة ⏳',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل تمديد الوقت: ${e.toString()}',
      ));
    }
  }

  /// حظر تطبيق معين
  Future<void> blockApp({
    required String childId,
    required String deviceId,
    required String packageName,
  }) async {
    if (packageName.trim().isEmpty) return;
    emit(state.copyWith(isSending: true));
    try {
      await manageAppRestrictionUseCase.blockApp(
        childId: childId,
        deviceId: deviceId,
        packageName: packageName.trim(),
      );
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم إرسال أمر حظر التطبيق: $packageName 🚫',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل حظر التطبيق: ${e.toString()}',
      ));
    }
  }

  /// إلغاء حظر تطبيق معين
  Future<void> unblockApp({
    required String childId,
    required String deviceId,
    required String packageName,
  }) async {
    if (packageName.trim().isEmpty) return;
    emit(state.copyWith(isSending: true));
    try {
      await manageAppRestrictionUseCase.unblockApp(
        childId: childId,
        deviceId: deviceId,
        packageName: packageName.trim(),
      );
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم إرسال أمر إلغاء حظر التطبيق: $packageName ✅',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل إلغاء حظر التطبيق: ${e.toString()}',
      ));
    }
  }

  /// طلب الموقع الجغرافي الفوري
  Future<void> requestLocation({
    required String childId,
    required String deviceId,
  }) async {
    emit(state.copyWith(isSending: true));
    try {
      await requestLocationUseCase.execute(childId: childId, deviceId: deviceId);
      emit(state.copyWith(
        isSending: false,
        successMessage: 'تم طلب تحديث الموقع الجغرافي الفوري 📍',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'فشل طلب الموقع: ${e.toString()}',
      ));
    }
  }

  /// مسح رسائل التنبيه بعد عرضها
  void clearMessages() {
    emit(state.copyWith(successMessage: null, errorMessage: null));
  }

  @override
  Future<void> close() {
    _commandsSubscription?.cancel();
    return super.close();
  }
}
