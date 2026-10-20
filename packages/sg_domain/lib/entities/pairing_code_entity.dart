import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 كيان كود الربط المؤقت (Pairing Code Entity)
// ----------------------------------------------------------------------------
// يمثل كود الربط الرقمي المكون من 6 أرقام لربط جهاز الطفل بحساب ولي الأمر.
// ============================================================================

class PairingCodeEntity extends Equatable {
  /// المعرف الفريد للكود
  final String id;

  /// الرمز الرقمي المكون من 6 أرقام (مثال: 582914)
  final String code;

  /// معرف حساب الأب الذي أنشأ الكود
  final String parentId;

  /// معرف الطفل المستهدف ربط جهازه
  final String childId;

  /// وقت انتهاء صلاحية الكود (صالح لمدة 10 دقائق افتراضياً)
  final DateTime expiresAt;

  /// هل تم استخدام الكود واقتران الجهاز بنجاح؟
  final bool isUsed;

  const PairingCodeEntity({
    required this.id,
    required this.code,
    required this.parentId,
    required this.childId,
    required this.expiresAt,
    this.isUsed = false,
  });

  /// هل انتهت صلاحية الكود الزمنية؟
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// هل الكود صالح للاستخدام حالياً؟
  bool get isValid => !isUsed && !isExpired;

  @override
  List<Object?> get props => [id, code, parentId, childId, expiresAt, isUsed];
}
