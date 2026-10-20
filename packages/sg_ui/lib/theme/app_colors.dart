import 'package:flutter/material.dart';

/// ============================================================================
/// 📌 الألوان الموحدة لمشروع Smart Guardian
/// ----------------------------------------------------------------------------
/// تضمن هوية بصرية متناسقة بين تطبيقي الأب والطفل وتدعم الثيم الفاتح والداكن.
/// ============================================================================

class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // الألوان الأساسية
  // ---------------------------------------------------------------------------
  /// اللون الأساسي (أزرق ملكي أمني يعبر عن الحماية والموثوقية)
  static const Color primary = Color(0xFF1E3A8A);

  /// اللون الثانوي (سماوي حديث للحالات التفاعلية)
  static const Color secondary = Color(0xFF0284C7);

  /// لون اللكنة (برتقالي دافئ لأزرار التنبيه والوقت)
  static const Color accent = Color(0xFFF97316);

  // ---------------------------------------------------------------------------
  // ألوان الحالات والإنذارات
  // ---------------------------------------------------------------------------
  /// أخضر للنجاح وحالة الأمان
  static const Color success = Color(0xFF10B981);

  /// برتقالي للتحذير (مثل اقتراب انتهاء الوقت)
  static const Color warning = Color(0xFFF59E0B);

  /// أحمر للقفل، الخطر، وزر الـ SOS
  static const Color danger = Color(0xFFEF4444);

  // ---------------------------------------------------------------------------
  // ألوان الخلفيات والنصوص للثيم الفاتح (Light Theme)
  // ---------------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // ---------------------------------------------------------------------------
  // ألوان الخلفيات والنصوص للثيم الداكن (Dark Theme)
  // ---------------------------------------------------------------------------
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
