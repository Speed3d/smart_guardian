// ============================================================================
// 📌 حزمة sg_domain - ملف التصدير العام
// ----------------------------------------------------------------------------
// يصدر كافة الكيانات ومنافذ المستودعات وحالات الاستخدام لطبقة الـ Domain.
// ============================================================================
library;

// الكيانات (Entities)
export 'entities/child_entity.dart';
export 'entities/command_entity.dart';
export 'entities/location_entity.dart';

// المستودعات المجردة (Repository Interfaces)
export 'repositories/command_repository.dart';

// حالات الاستخدام (Use Cases)
export 'usecases/lock_device_usecase.dart';
