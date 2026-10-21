import 'package:firebase_core/firebase_core.dart';
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
// يدعم التشغيل السحابي عبر Firebase والتشغيل المحلي التفاعلي InMemory Fallback.
// ============================================================================

final sl = GetIt.instance;

Future<void> initChildServiceLocator({
  FirestoreCommandDataSource? mockCommandDataSource,
  FirestorePairingDataSource? mockPairingDataSource,
  FirestoreUsageDataSource? mockUsageDataSource,
}) async {
  final isFirebaseReady = Firebase.apps.isNotEmpty;

  // 1. مصادر البيانات (Data Sources)
  // يتم فحص جاهزية Firebase: إن كانت مهيأة تُستخدم مصادر Firestore الأصلية،
  // وإلا يتم التحويل التلقائي لمصادر الذاكرة InMemory لمنع الانهيار وتمكين التجربة الفورية.
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
