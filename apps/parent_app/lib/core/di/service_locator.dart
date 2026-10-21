import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/children/presentation/cubit/manage_child_cubit.dart';
import '../../features/commands/presentation/cubit/command_cubit.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/pairing/presentation/cubit/pairing_code_cubit.dart';

// ============================================================================
// 📌 محدد وموزع الخدمات لتطبيق الأب (Service Locator - GetIt)
// ----------------------------------------------------------------------------
// يدير حقن التبعيات (Dependency Injection) لكافة المستودعات والـ Use Cases والـ Cubits.
// يدعم التبديل الآلي بين Firebase السحابي ونمط المحاكاة المباشر InMemory.
// ============================================================================

final sl = GetIt.instance;

Future<void> initServiceLocator({
  FirebaseAuthDataSource? mockAuthDataSource,
  FirestoreChildDataSource? mockChildDataSource,
  FirestoreCommandDataSource? mockCommandDataSource,
  FirestorePairingDataSource? mockPairingDataSource,
  FirestoreUsageDataSource? mockUsageDataSource,
}) async {
  final isFirebaseReady = Firebase.apps.isNotEmpty;

  // ---------------------------------------------------------------------------
  // 1. مصادر البيانات (Data Sources)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () =>
        mockAuthDataSource ??
        (isFirebaseReady
            ? FirebaseAuthDataSourceImpl()
            : InMemoryAuthDataSource()),
  );

  sl.registerLazySingleton<FirestoreChildDataSource>(
    () =>
        mockChildDataSource ??
        (isFirebaseReady
            ? FirestoreChildDataSourceImpl()
            : InMemoryChildDataSource()),
  );

  sl.registerLazySingleton<FirestoreCommandDataSource>(
    () =>
        mockCommandDataSource ??
        (isFirebaseReady
            ? FirestoreCommandDataSourceImpl()
            : InMemoryCommandDataSource()),
  );

  sl.registerLazySingleton<FirestorePairingDataSource>(
    () =>
        mockPairingDataSource ??
        (isFirebaseReady
            ? FirestorePairingDataSourceImpl()
            : InMemoryPairingDataSource()),
  );

  sl.registerLazySingleton<FirestoreUsageDataSource>(
    () =>
        mockUsageDataSource ??
        (isFirebaseReady
            ? FirestoreUsageDataSourceImpl()
            : InMemoryUsageDataSource()),
  );

  // ---------------------------------------------------------------------------
  // 2. المستودعات (Repositories)
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // 3. حالات الاستخدام (Use Cases)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl()),
  );

  sl.registerLazySingleton<GetChildrenUseCase>(
    () => GetChildrenUseCase(sl()),
  );

  sl.registerLazySingleton<AddChildUseCase>(
    () => AddChildUseCase(sl()),
  );

  sl.registerLazySingleton<LockDeviceUseCase>(
    () => LockDeviceUseCase(sl()),
  );

  sl.registerLazySingleton<UnlockDeviceUseCase>(
    () => UnlockDeviceUseCase(sl()),
  );

  sl.registerLazySingleton<ExtendScreenTimeUseCase>(
    () => ExtendScreenTimeUseCase(sl()),
  );

  sl.registerLazySingleton<ManageAppRestrictionUseCase>(
    () => ManageAppRestrictionUseCase(sl()),
  );

  sl.registerLazySingleton<RequestLocationUseCase>(
    () => RequestLocationUseCase(sl()),
  );

  sl.registerLazySingleton<GeneratePairingCodeUseCase>(
    () => GeneratePairingCodeUseCase(sl()),
  );

  // ---------------------------------------------------------------------------
  // 4. إدارة الحالة (Blocs & Cubits)
  // ---------------------------------------------------------------------------
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepository: sl(),
      signInUseCase: sl(),
    ),
  );

  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getChildrenUseCase: sl(),
      lockDeviceUseCase: sl(),
      childRepository: sl(),
    ),
  );

  sl.registerFactory<PairingCodeCubit>(
    () => PairingCodeCubit(
      generatePairingCodeUseCase: sl(),
    ),
  );

  sl.registerFactory<ManageChildCubit>(
    () => ManageChildCubit(
      addChildUseCase: sl(),
    ),
  );

  sl.registerFactory<CommandCubit>(
    () => CommandCubit(
      lockDeviceUseCase: sl(),
      unlockDeviceUseCase: sl(),
      extendScreenTimeUseCase: sl(),
      manageAppRestrictionUseCase: sl(),
      requestLocationUseCase: sl(),
      commandRepository: sl(),
    ),
  );
}
