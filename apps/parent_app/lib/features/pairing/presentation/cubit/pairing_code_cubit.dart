import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_domain/sg_domain.dart';
import 'pairing_code_state.dart';

// ============================================================================
// 📌 إدارة توليد كود الربط (Pairing Code Cubit)
// ----------------------------------------------------------------------------
// يطلب توليد كود رقمي مؤقت لربط هاتف الطفل ويعرضه للأب.
// ============================================================================

class PairingCodeCubit extends Cubit<PairingCodeState> {
  final GeneratePairingCodeUseCase generatePairingCodeUseCase;

  PairingCodeCubit({
    required this.generatePairingCodeUseCase,
  }) : super(const PairingCodeState());

  /// توليد كود ربط جديد لطفل محدد
  Future<void> generateCode({
    required String parentId,
    required String childId,
  }) async {
    emit(state.copyWith(status: PairingStatus.loading));
    try {
      final code = await generatePairingCodeUseCase.execute(
        parentId: parentId,
        childId: childId,
      );
      emit(state.copyWith(
        status: PairingStatus.success,
        pairingCode: code,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PairingStatus.failure,
        errorMessage: 'فشل توليد كود الربط: ${e.toString()}',
      ));
    }
  }
}
