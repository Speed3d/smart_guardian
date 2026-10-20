import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'manage_child_state.dart';

// ============================================================================
// 📌 إدارة إضافة وتعديل بيانات الطفل (Manage Child Cubit)
// ----------------------------------------------------------------------------
// يدير حفظ وتحديث ملفات الأطفال وتحديد الحد اليومي لوقت الشاشة.
// ============================================================================

class ManageChildCubit extends Cubit<ManageChildState> {
  final AddChildUseCase addChildUseCase;

  ManageChildCubit({
    required this.addChildUseCase,
  }) : super(const ManageChildState());

  /// إضافة طفل جديد
  Future<void> addNewChild({
    required String parentId,
    required String name,
    required int age,
    required int dailyLimitMinutes,
  }) async {
    emit(state.copyWith(status: ManageChildStatus.loading));
    try {
      final child = await addChildUseCase.execute(
        parentId: parentId,
        name: name,
        age: age,
        dailyScreenTimeLimitMinutes: dailyLimitMinutes,
      );
      emit(state.copyWith(
        status: ManageChildStatus.success,
        child: child,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ManageChildStatus.failure,
        errorMessage: 'فشل إضافة الطفل: ${e.toString()}',
      ));
    }
  }
}
