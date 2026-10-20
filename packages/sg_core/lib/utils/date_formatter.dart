// ============================================================================
// 📌 أدوات مساعدة لتنسيق الوقت والتواريخ (Date & Time Utils)
// ----------------------------------------------------------------------------
// دوال عامة لتحويل الدقائق إلى صيغة (ساعة ودقيقة) وحساب الوقت المتبقي
// لشاشة استخدام الطفل بدقة وبدون تعقيد.
// ============================================================================

class AppDateUtils {
  const AppDateUtils._();

  /// تحويل عدد الدقائق إلى نص مفهوم (مثال: ساعتان و 15 دقيقة)
  static String formatDurationMinutes(int totalMinutes) {
    if (totalMinutes <= 0) {
      return 'انتهى الوقت';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) {
      return '$minutes دقيقة';
    } else if (minutes == 0) {
      return '$hours ساعة';
    } else {
      return '$hours ساعة و $minutes دقيقة';
    }
  }

  /// التحقق مما إذا كان التاريخ يقع في نفس اليوم الحالي
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
