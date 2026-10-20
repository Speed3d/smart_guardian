import '../entities/command_entity.dart';

/// ============================================================================
/// 📌 واجهة مستودع الأوامر (Command Repository Interface)
/// ----------------------------------------------------------------------------
/// عقد تجريدي (Contract) يحدد كيف يتم إرسال واستقبال وتتبع الأوامر الفورية
/// بين تطبيقي الأب والطفل دون التقيد بمصدر بيانات محدد.
/// ============================================================================

abstract class CommandRepository {
  /// إرسال أمر فوري من الأب إلى جهاز الطفل (مثل القفل، فك القفل، تمديد الوقت، حظر تطبيق)
  Future<void> sendCommand(CommandEntity command);

  /// الاستماع المباشر للأوامر المعلقة والموجهة لجهاز الطفل الحالي
  Stream<CommandEntity> listenToChildCommands(String childId, String deviceId);

  /// الاستماع المباشر لآخر الأوامر الصادرة لطفل معين لمتابعة حالة تنفيذها في تطبيق الأب
  Stream<List<CommandEntity>> listenToRecentCommands(String childId);

  /// تحديث حالة الأمر (تم التنفيذ، فشل التنفيذ) من قبل تطبيق الطفل
  Future<void> updateCommandStatus(String commandId, CommandStatus status);
}
