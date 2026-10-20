// ============================================================================
// 📌 حزمة sg_domain - ملف التصدير العام
// ----------------------------------------------------------------------------
// يصدر كافة الكيانات ومنافذ المستودعات وحالات الاستخدام لطبقة الـ Domain.
// ============================================================================
library;

// الكيانات (Entities)
export 'entities/child_entity.dart';
export 'entities/command_entity.dart';
export 'entities/device_entity.dart';
export 'entities/location_entity.dart';
export 'entities/pairing_code_entity.dart';
export 'entities/usage_report_entity.dart';
export 'entities/user_entity.dart';

// المستودعات المجردة (Repository Interfaces)
export 'repositories/auth_repository.dart';
export 'repositories/child_repository.dart';
export 'repositories/command_repository.dart';
export 'repositories/pairing_repository.dart';
export 'repositories/usage_repository.dart';

// حالات الاستخدام (Use Cases)
export 'usecases/acknowledge_command_usecase.dart';
export 'usecases/add_child_usecase.dart';
export 'usecases/extend_screen_time_usecase.dart';
export 'usecases/generate_pairing_code_usecase.dart';
export 'usecases/get_children_usecase.dart';
export 'usecases/listen_to_child_commands_usecase.dart';
export 'usecases/lock_device_usecase.dart';
export 'usecases/manage_app_restriction_usecase.dart';
export 'usecases/request_location_usecase.dart';
export 'usecases/sign_in_usecase.dart';
export 'usecases/sync_daily_usage_usecase.dart';
export 'usecases/unlock_device_usecase.dart';
export 'usecases/verify_pairing_code_usecase.dart';
