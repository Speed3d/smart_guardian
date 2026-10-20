import 'package:get_it/get_it.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../features/auth/presentation/cubit/admin_auth_cubit.dart';
import '../../features/dashboard/presentation/cubit/admin_dashboard_cubit.dart';

// ============================================================================
// 📌 محدد وموزع الخدمات للوحة الإدارة الويب (Admin Portal Service Locator)
// ----------------------------------------------------------------------------
// يدير حقن التبعيات (DI) لمستودعات البيانات و Cubits الخاصة بلوحة الدعم والتحكم.
// ============================================================================

final sl = GetIt.instance;

Future<void> initAdminServiceLocator({
  FirebaseAuthDataSource? mockAuthDataSource,
  FirestoreChildDataSource? mockChildDataSource,
  FirestoreCommandDataSource? mockCommandDataSource,
  FirestorePairingDataSource? mockPairingDataSource,
  FirestoreUsageDataSource? mockUsageDataSource,
}) async {
  // 1. مصادر البيانات (Data Sources)
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => mockAuthDataSource ?? FirebaseAuthDataSourceImpl(),
  );

  sl.registerLazySingleton<FirestoreChildDataSource>(
    () => mockChildDataSource ?? FirestoreChildDataSourceImpl(),
  );

  sl.registerLazySingleton<FirestoreCommandDataSource>(
    () => mockCommandDataSource ?? FirestoreCommandDataSourceImpl(),
  );

  sl.registerLazySingleton<FirestorePairingDataSource>(
    () => mockPairingDataSource ?? FirestorePairingDataSourceImpl(),
  );

  sl.registerLazySingleton<FirestoreUsageDataSource>(
    () => mockUsageDataSource ?? FirestoreUsageDataSourceImpl(),
  );

  // 2. المستودعات (Repositories)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ChildRepository>(
    () => ChildRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<PairingRepository>(
    () => PairingRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<UsageRepository>(
    () => UsageRepositoryImpl(sl()),
  );

  // 3. حالات الاستخدام (Use Cases)
  sl.registerLazySingleton<LockDeviceUseCase>(
    () => LockDeviceUseCase(sl()),
  );

  sl.registerLazySingleton<UnlockDeviceUseCase>(
    () => UnlockDeviceUseCase(sl()),
  );

  // 4. إدارة الحالة (Cubits)
  sl.registerFactory<AdminAuthCubit>(
    () => AdminAuthCubit(),
  );

  sl.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(
      childRepository: sl(),
      commandRepository: sl(),
      lockDeviceUseCase: sl(),
      unlockDeviceUseCase: sl(),
    ),
  );
}
