import '../entities/command_entity.dart';

/// ============================================================================
/// 📌 واجهة مستودع الأوامر (Command Repository Interface)
/// ----------------------------------------------------------------------------
/// عقد تجريدي (Contract) يحدد كيف يتم إرسال واستقبال الأوامر دون التقيد بـ Firebase أو غيره.
/// ============================================================================

abstract class CommandRepository {
  /// إرسال أمر فوري من الأب إلى جهاز الطفل (مثل القفل أو فتح القفل)
  Future<void> sendCommand(CommandEntity command);

  /// الاستماع المباشر للأوامر الموجهة لجهاز الطفل الحالي
  Stream<CommandEntity> listenToChildCommands(String childId, String deviceId);

  /// تحديث حالة الأمر بعد تنفيذه من قبل تطبيق الطفل
  Future<void> updateCommandStatus(String commandId, CommandStatus status);
}
