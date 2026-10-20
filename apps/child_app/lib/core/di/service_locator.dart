import 'package:get_it/get_it.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../features/pairing/presentation/cubit/pairing_input_cubit.dart';
import '../../features/status/domain/batch_usage_syncer.dart';
import '../../features/status/domain/child_command_dispatcher.dart';
import '../../features/status/presentation/cubit/child_status_cubit.dart';

// ============================================================================
// 📌 محدد وموزع الخدمات لتطبيق الطفل (Service Locator - GetIt)
// ----------------------------------------------------------------------------
// يدير حقن التبعيات لمستودعات الأوامر، المزامنة، والاقتران لـ Child App.
// ============================================================================

final sl = GetIt.instance;

Future<void> initChildServiceLocator({
  FirestoreCommandDataSource? mockCommandDataSource,
  FirestorePairingDataSource? mockPairingDataSource,
  FirestoreUsageDataSource? mockUsageDataSource,
}) async {
  // 1. مصادر البيانات (Data Sources)
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
  sl.registerLazySingleton<VerifyPairingCodeUseCase>(
    () => VerifyPairingCodeUseCase(sl()),
  );

  sl.registerLazySingleton<ListenToChildCommandsUseCase>(
    () => ListenToChildCommandsUseCase(sl()),
  );

  sl.registerLazySingleton<AcknowledgeCommandUseCase>(
    () => AcknowledgeCommandUseCase(sl()),
  );

  sl.registerLazySingleton<SyncDailyUsageUseCase>(
    () => SyncDailyUsageUseCase(sl()),
  );

  // 4. خدمات الأوامر والمزامنة في الخلفية (Services & Dispatchers)
  sl.registerLazySingleton<ChildCommandDispatcher>(
    () => ChildCommandDispatcher(
      listenToCommandsUseCase: sl(),
      acknowledgeCommandUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<BatchUsageSyncer>(
    () => BatchUsageSyncer(
      syncDailyUsageUseCase: sl(),
    ),
  );

  // 5. إدارة الحالة (Cubits)
  sl.registerFactory<ChildStatusCubit>(
    () => ChildStatusCubit(
      commandDispatcher: sl(),
      usageSyncer: sl(),
    ),
  );

  sl.registerFactory<PairingInputCubit>(
    () => PairingInputCubit(verifyPairingCodeUseCase: sl()),
  );
}
