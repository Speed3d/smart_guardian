import 'package:equatable/equatable.dart';
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 حالات إدارة الطفل (Manage Child States)
// ----------------------------------------------------------------------------
// تمثل حالات إضافة وتعديل ملف الطفل.
// ============================================================================

enum ManageChildStatus { initial, loading, success, failure }

class ManageChildState extends Equatable {
  final ManageChildStatus status;
  final ChildEntity? child;
  final String? errorMessage;

  const ManageChildState({
    this.status = ManageChildStatus.initial,
    this.child,
    this.errorMessage,
  });

  ManageChildState copyWith({
    ManageChildStatus? status,
    ChildEntity? child,
    String? errorMessage,
  }) {
    return ManageChildState(
      status: status ?? this.status,
      child: child ?? this.child,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, child, errorMessage];
}
