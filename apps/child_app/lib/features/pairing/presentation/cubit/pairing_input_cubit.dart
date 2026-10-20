import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'pairing_input_state.dart';

// ============================================================================
// 📌 إدارة إدخال كود الربط (Pairing Input Cubit)
// ----------------------------------------------------------------------------
// يدير التحقق من رمز الـ 6 أرقام وربط هاتف الطفل بحساب ولي الأمر.
// ============================================================================

class PairingInputCubit extends Cubit<PairingInputState> {
  final VerifyPairingCodeUseCase verifyPairingCodeUseCase;

  PairingInputCubit({
    required this.verifyPairingCodeUseCase,
  }) : super(const PairingInputState());

  /// التحقق من الكود وإتمام الاقتران
  Future<void> submitPairingCode({
    required String code,
    required String deviceId,
    required String deviceModel,
    required String osVersion,
  }) async {
    final cleanCode = code.trim();
    if (cleanCode.length != AppConstants.pairingCodeLength) {
      emit(state.copyWith(
        status: PairingInputStatus.failure,
        errorMessage: 'يرجى إدخال رمز الربط المكون من 6 أرقام كاملاً.',
      ));
      return;
    }

    emit(state.copyWith(status: PairingInputStatus.loading));
    try {
      final result = await verifyPairingCodeUseCase.execute(
        code: cleanCode,
        deviceId: deviceId,
        deviceModel: deviceModel,
        osVersion: osVersion,
      );

      emit(state.copyWith(
        status: PairingInputStatus.success,
        pairedData: result,
      ));
    } on Failure catch (e) {
      emit(state.copyWith(
        status: PairingInputStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PairingInputStatus.failure,
        errorMessage: 'فشل ربط الجهاز: ${e.toString()}',
      ));
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    emit(const PairingInputState());
  }
}
