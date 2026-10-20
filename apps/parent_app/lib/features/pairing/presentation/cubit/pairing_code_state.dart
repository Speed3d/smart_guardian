import 'package:equatable/equatable.dart';
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 حالات كود الربط (Pairing Code States)
// ----------------------------------------------------------------------------
// تمثل حالات توليد الكود (جاري التوليد، تم التوليد بنجاح، خطأ).
// ============================================================================

enum PairingStatus { initial, loading, success, failure }

class PairingCodeState extends Equatable {
  final PairingStatus status;
  final PairingCodeEntity? pairingCode;
  final String? errorMessage;

  const PairingCodeState({
    this.status = PairingStatus.initial,
    this.pairingCode,
    this.errorMessage,
  });

  PairingCodeState copyWith({
    PairingStatus? status,
    PairingCodeEntity? pairingCode,
    String? errorMessage,
  }) {
    return PairingCodeState(
      status: status ?? this.status,
      pairingCode: pairingCode ?? this.pairingCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pairingCode, errorMessage];
}
