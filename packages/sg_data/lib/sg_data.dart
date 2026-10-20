// ============================================================================
// 📌 حزمة sg_data - ملف التصدير العام
// ----------------------------------------------------------------------------
// يصدر كافة نماذج البيانات (DTOs) ومصادر البيانات ومستودعات التخزين.
// ============================================================================
library;

// نماذج البيانات (Models)
export 'models/child_model.dart';
export 'models/command_model.dart';
export 'models/device_model.dart';
export 'models/pairing_code_model.dart';
export 'models/user_model.dart';

// مصادر البيانات (Data Sources)
export 'datasources/remote/firebase_auth_datasource.dart';
export 'datasources/remote/firestore_child_datasource.dart';
export 'datasources/remote/firestore_command_datasource.dart';
export 'datasources/remote/firestore_pairing_datasource.dart';

// تطبيقات المستودعات (Repository Implementations)
export 'repositories/auth_repository_impl.dart';
export 'repositories/child_repository_impl.dart';
export 'repositories/command_repository_impl.dart';
export 'repositories/pairing_repository_impl.dart';
