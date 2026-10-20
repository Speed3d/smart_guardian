import 'package:get_it/get_it.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../features/status/presentation/cubit/child_status_cubit.dart';

// ============================================================================
// 📌 محدد وموزع الخدمات لتطبيق الطفل (Service Locator - GetIt)
// ----------------------------------------------------------------------------
// يدير حقن التبعيات لمستودعات الأوامر و Cubits لتطبيق الطفل.
// ============================================================================

final sl = GetIt.instance;

Future<void> initChildServiceLocator({
  FirestoreCommandDataSource? mockCommandDataSource,
}) async {
  // 1. مصادر البيانات
  sl.registerLazySingleton<FirestoreCommandDataSource>(
    () => mockCommandDataSource ?? FirestoreCommandDataSourceImpl(),
  );

  // 2. المستودعات
  sl.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(sl()),
  );

  // 3. إدارة الحالة (Cubit)
  sl.registerFactory<ChildStatusCubit>(
    () => ChildStatusCubit(commandRepository: sl()),
  );
}
