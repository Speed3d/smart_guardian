import 'package:get_it/get_it.dart';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../features/pairing/presentation/cubit/pairing_input_cubit.dart';
import '../../features/status/presentation/cubit/child_status_cubit.dart';

// ============================================================================
// 📌 محدد وموزع الخدمات لتطبيق الطفل (Service Locator - GetIt)
// ----------------------------------------------------------------------------
// يدير حقن التبعيات لمستودعات الأوامر والاقتران و Cubits لتطبيق الطفل.
// ============================================================================

final sl = GetIt.instance;

Future<void> initChildServiceLocator({
  FirestoreCommandDataSource? mockCommandDataSource,
  FirestorePairingDataSource? mockPairingDataSource,
}) async {
  // 1. مصادر البيانات
  sl.registerLazySingleton<FirestoreCommandDataSource>(
    () => mockCommandDataSource ?? FirestoreCommandDataSourceImpl(),
  );

  sl.registerLazySingleton<FirestorePairingDataSource>(
    () => mockPairingDataSource ?? FirestorePairingDataSourceImpl(),
  );

  // 2. المستودعات
  sl.registerLazySingleton<CommandRepository>(
    () => CommandRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<PairingRepository>(
    () => PairingRepositoryImpl(sl()),
  );

  // 3. حالات الاستخدام (Use Cases)
  sl.registerLazySingleton<VerifyPairingCodeUseCase>(
    () => VerifyPairingCodeUseCase(sl()),
  );

  // 4. إدارة الحالة (Cubits)
  sl.registerFactory<ChildStatusCubit>(
    () => ChildStatusCubit(commandRepository: sl()),
  );

  sl.registerFactory<PairingInputCubit>(
    () => PairingInputCubit(verifyPairingCodeUseCase: sl()),
  );
}
