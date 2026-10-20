import 'package:equatable/equatable.dart';
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 حالات لوحة تحكم الأب (Dashboard States)
// ----------------------------------------------------------------------------
// تمثل الحالات المختلفة لشاشة لوحة التحكم (تحميل، نجاح، خطأ).
// ============================================================================

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<ChildEntity> children;
  final String? errorMessage;
  final bool isActionInProgress;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.children = const [],
    this.errorMessage,
    this.isActionInProgress = false,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    List<ChildEntity>? children,
    String? errorMessage,
    bool? isActionInProgress,
  }) {
    return DashboardState(
      status: status ?? this.status,
      children: children ?? this.children,
      errorMessage: errorMessage ?? this.errorMessage,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
    );
  }

  @override
  List<Object?> get props => [status, children, errorMessage, isActionInProgress];
}
