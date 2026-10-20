// ============================================================================
// 📌 كيان الموقع الجغرافي (Location Entity)
// ----------------------------------------------------------------------------
// يمثل إحداثيات موقع الطفل، ويُرسل بشكل مجمع (Batched) لتوفير استهلاك البيانات والبطارية.
// ============================================================================

class LocationEntity {
  /// خط العرض
  final double latitude;

  /// خط الطول
  final double longitude;

  /// نسبة الدقة بالأمتار
  final double? accuracy;

  /// مستوى شحن بطارية الجهاز أثناء تسجيل الموقع
  final int? batteryLevel;

  /// توقيت تسجيل هذا الموقع
  final DateTime timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.batteryLevel,
    required this.timestamp,
  });
}
