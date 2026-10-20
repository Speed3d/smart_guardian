// ============================================================================
// 📌 الاستثناءات البرمجية (Exceptions)
// ----------------------------------------------------------------------------
// الاستثناءات تُرمى في طبقة البيانات (Data Layer) عند فشل استدعاء Firebase،
// أو قنوات الاتصال الأصلية (Platform Channels)، ويتم التقاطها وتحويلها إلى [Failure].
// ============================================================================

class ServerException implements Exception {
  final String message;
  final String? code;
  const ServerException(this.message, {this.code});

  @override
  String toString() => 'ServerException: $message (code: $code)';
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}

class PlatformBridgeException implements Exception {
  final String message;
  final String? platform;
  const PlatformBridgeException(this.message, {this.platform});

  @override
  String toString() => 'PlatformBridgeException ($platform): $message';
}
