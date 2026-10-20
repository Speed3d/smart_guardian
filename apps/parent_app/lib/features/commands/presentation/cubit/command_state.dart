import 'package:equatable/equatable.dart';
import 'package:sg_domain/sg_domain.dart';

// ============================================================================
// 📌 حالات إدارة أوامر التحكم عن بعد (Command Cubit States)
// ----------------------------------------------------------------------------
// تمثل حالة إرسال الأوامر وقائمة الأوامر الحديثة وحالة تنفيذها على هاتف الطفل.
// ============================================================================

class CommandState extends Equatable {
  final bool isSending;
  final List<CommandEntity> recentCommands;
  final String? successMessage;
  final String? errorMessage;

  const CommandState({
    this.isSending = false,
    this.recentCommands = const [],
    this.successMessage,
    this.errorMessage,
  });

  CommandState copyWith({
    bool? isSending,
    List<CommandEntity>? recentCommands,
    String? successMessage,
    String? errorMessage,
  }) {
    return CommandState(
      isSending: isSending ?? this.isSending,
      recentCommands: recentCommands ?? this.recentCommands,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isSending,
        recentCommands,
        successMessage,
        errorMessage,
      ];
}
