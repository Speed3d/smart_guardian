import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'dashboard_state.dart';

// ============================================================================
// 📌 إدارة حالة لوحة تحكم الأب (Dashboard Cubit)
// ----------------------------------------------------------------------------
// يدير جلب أطفال ولي الأمر وإرسال أوامر القفل وتمديد الوقت لحظياً.
// ============================================================================

class DashboardCubit extends Cubit<DashboardState> {
  final GetChildrenUseCase getChildrenUseCase;
  final LockDeviceUseCase lockDeviceUseCase;
  final ChildRepository childRepository;
  StreamSubscription<List<ChildEntity>>? _childrenSubscription;

  DashboardCubit({
    required this.getChildrenUseCase,
    required this.lockDeviceUseCase,
    required this.childRepository,
  }) : super(const DashboardState());

  /// تحميل تدفق الأطفال لولي الأمر
  void loadParentDashboard(String parentId) {
    emit(state.copyWith(status: DashboardStatus.loading));
    _childrenSubscription?.cancel();
    _childrenSubscription = getChildrenUseCase.execute(parentId).listen(
      (children) {
        emit(state.copyWith(
          status: DashboardStatus.success,
          children: children,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  /// تبديل حالة قفل جهاز الطفل فورياً
  Future<void> toggleChildLock({
    required String childId,
    required String deviceId,
    required bool currentLockState,
  }) async {
    emit(state.copyWith(isActionInProgress: true));
    try {
      final newLockState = !currentLockState;
      // 1. إرسال أمر القفل للطفل عبر FCM و Firestore
      await lockDeviceUseCase.execute(childId: childId, deviceId: deviceId);
      // 2. تحديث الحالة في مستند الطفل
      await childRepository.updateChildLockStatus(childId, newLockState);

      // تحديث القائمة محلياً للعرض السريع
      final updatedList = state.children.map((c) {
        if (c.id == childId) {
          return c.copyWith(isLocked: newLockState);
        }
        return c;
      }).toList();

      emit(state.copyWith(
        children: updatedList,
        isActionInProgress: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isActionInProgress: false,
        errorMessage: 'فشل تغيير حالة القفل: ${e.toString()}',
      ));
    }
  }

  /// تمديد وقت استخدام الطفل بالدقائق
  Future<void> extendTime(String childId, int additionalMinutes) async {
    emit(state.copyWith(isActionInProgress: true));
    try {
      await childRepository.extendScreenTime(childId, additionalMinutes);
      emit(state.copyWith(isActionInProgress: false));
    } catch (e) {
      emit(state.copyWith(
        isActionInProgress: false,
        errorMessage: 'فشل تمديد الوقت: ${e.toString()}',
      ));
    }
  }

  @override
  Future<void> close() {
    _childrenSubscription?.cancel();
    return super.close();
  }
}
