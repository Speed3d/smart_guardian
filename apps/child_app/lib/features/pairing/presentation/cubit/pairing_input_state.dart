import 'package:equatable/equatable.dart';
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 حالات إدخال كود الربط (Pairing Input States)
// ----------------------------------------------------------------------------
// تمثل حالات إدخال الكود في هاتف الطفل (بانتظار الإدخال، جاري التحقق، نجاح، خطأ).
// ============================================================================

enum PairingInputStatus { initial, loading, success, failure }

class PairingInputState extends Equatable {
  final PairingInputStatus status;
  final PairingCodeEntity? pairedData;
  final String? errorMessage;

  const PairingInputState({
    this.status = PairingInputStatus.initial,
    this.pairedData,
    this.errorMessage,
  });

  PairingInputState copyWith({
    PairingInputStatus? status,
    PairingCodeEntity? pairedData,
    String? errorMessage,
  }) {
    return PairingInputState(
      status: status ?? this.status,
      pairedData: pairedData ?? this.pairedData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pairedData, errorMessage];
}
