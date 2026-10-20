import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'admin_dashboard_state.dart';

// ============================================================================
// 📌 إدارة بيانات لوحة المشرف الويب (Admin Dashboard Cubit)
// ----------------------------------------------------------------------------
// يدير إحصائيات النظام الشاملة، والبحث في العوائل، والتدخل الطارئ لفرق الدعم.
// ============================================================================

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final ChildRepository childRepository;
  final CommandRepository commandRepository;
  final LockDeviceUseCase lockDeviceUseCase;
  final UnlockDeviceUseCase unlockDeviceUseCase;

  AdminDashboardCubit({
    required this.childRepository,
    required this.commandRepository,
    required this.lockDeviceUseCase,
    required this.unlockDeviceUseCase,
  }) : super(const AdminDashboardState()) {
    loadDashboardData();
  }

  /// تحميل البيانات والإحصائيات الأولية
  void loadDashboardData() {
    emit(state.copyWith(
      families: [
        AdminFamilyItem(
          id: 'fam_101',
          parentName: 'عبدالله محمد',
          email: 'abdullah@example.com',
          plan: 'Pro Plan (السنوي)',
          childrenCount: 3,
          isActive: true,
          registeredAt: DateTime(2026, 2, 10),
        ),
        AdminFamilyItem(
          id: 'fam_102',
          parentName: 'سارة خالد',
          email: 'sara.k@example.com',
          plan: 'Free Tier (المجاني)',
          childrenCount: 1,
          isActive: true,
          registeredAt: DateTime(2026, 3, 15),
        ),
        AdminFamilyItem(
          id: 'fam_103',
          parentName: 'عمر التميمي',
          email: 'omar.t@example.com',
          plan: 'Pro Plan (الشهري)',
          childrenCount: 2,
          isActive: true,
          registeredAt: DateTime(2026, 4, 1),
        ),
        AdminFamilyItem(
          id: 'fam_104',
          parentName: 'نورة الدوسري',
          email: 'noura.d@example.com',
          plan: 'Family Plus',
          childrenCount: 4,
          isActive: true,
          registeredAt: DateTime(2026, 5, 20),
        ),
      ],
    ));
  }

  /// تبديل التبويب النشط في القائمة الجانبية
  void setTab(int tabIndex) {
    emit(state.copyWith(selectedTab: tabIndex));
  }

  /// البحث السريع في العوائل
  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// فك قفل طارئ لجهاز طفل من قبل فريق الدعم الفني
  Future<void> emergencyUnlockDevice({
    required String childId,
    required String deviceId,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await unlockDeviceUseCase.execute(childId: childId, deviceId: deviceId);
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم إرسال أمر فك القفل الطارئ للجهاز ($deviceId) بنجاح 🔓',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل إرسال أمر فك القفل: ${e.toString()}',
      ));
    }
  }

  /// قفل طارئ لجهاز طفل من قبل فريق الدعم الفني
  Future<void> emergencyLockDevice({
    required String childId,
    required String deviceId,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await lockDeviceUseCase.execute(childId: childId, deviceId: deviceId);
      emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم إرسال أمر القفل الطارئ للجهاز ($deviceId) بنجاح 🔒',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل إرسال أمر القفل: ${e.toString()}',
      ));
    }
  }

  /// مسح رسائل التنبيه
  void clearMessage() {
    emit(state.copyWith(successMessage: null, errorMessage: null));
  }
}
