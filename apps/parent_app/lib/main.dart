import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_ui/sg_ui.dart';

import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/children/presentation/cubit/manage_child_cubit.dart';
import 'features/children/presentation/views/add_edit_child_screen.dart';
import 'features/commands/presentation/cubit/command_cubit.dart';
import 'features/commands/presentation/views/remote_control_sheet.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_state.dart';
import 'features/pairing/presentation/cubit/pairing_code_cubit.dart';
import 'features/pairing/presentation/views/generate_pairing_code_screen.dart';

// ============================================================================
// 📌 نقطة انطلاق تطبيق الأب (Smart Guardian Parent)
// ----------------------------------------------------------------------------
// يدمج BLoC/Cubit لإدارة الحالة و GetIt لحقن التبعيات والتواصل مع Firebase.
// يدعم التشغيل الآمن Offline/Demo في حال عدم ربط Firebase بعد.
// ============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('⚠️ Firebase not initialized: running in safe demo/in-memory mode: $e');
  }
  await initServiceLocator();
  runApp(const SmartGuardianParentApp());
}

class SmartGuardianParentApp extends StatelessWidget {
  const SmartGuardianParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) =>
              sl<DashboardCubit>()..loadParentDashboard('demo_parent_id'),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ParentDashboardScreen(),
      ),
    );
  }
}

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأب - Smart Guardian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'إضافة طفل',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<ManageChildCubit>(
                    create: (_) => sl<ManageChildCubit>(),
                    child: const AddEditChildScreen(parentId: 'demo_parent_id'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
          builder: (context, state) {
            // أطفال تجريبيين إذا لم تتوفر بيانات بعد
            final child = state.children.isNotEmpty
                ? state.children.first
                : ChildEntity(
                    id: 'child_demo_1',
                    parentId: 'demo_parent_id',
                    name: 'أحمد',
                    age: 10,
                    dailyScreenTimeLimitMinutes: 120,
                    usedScreenTimeTodayMinutes: 45,
                    isLocked: false,
                    lastActiveAt: DateTime.now(),
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // بطاقة ترحيبية
                  SgCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withAlpha(30),
                          child: const Icon(
                            Icons.family_restroom,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحباً بك، ولي الأمر',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'حالة الأجهزة: متصلة وآمنة ✅',
                                style: TextStyle(
                                  color: AppColors.lightTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // بطاقة الطفل وإحصائياته الحية
                  SgCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'جهاز: ${child.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: child.isLocked
                                    ? AppColors.danger.withAlpha(25)
                                    : AppColors.success.withAlpha(25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                child.isLocked ? 'الجهاز مقفل 🔒' : 'نشط الآن 🟢',
                                style: TextStyle(
                                  color: child.isLocked
                                      ? AppColors.danger
                                      : AppColors.success,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.timer,
                              label: 'الوقت المتبقي',
                              value: AppDateUtils.formatDurationMinutes(
                                  child.remainingMinutes),
                            ),
                            _buildStatItem(
                              icon: Icons.battery_charging_full,
                              label: 'البطارية',
                              value: '84%',
                            ),
                            _buildStatItem(
                              icon: Icons.location_on,
                              label: 'الموقع',
                              value: 'المنزل 🏠',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // زر تفعيل / إلغاء القفل
                        SizedBox(
                          width: double.infinity,
                          child: SgButton(
                            label: child.isLocked
                                ? 'إلغاء قفل الجهاز'
                                : 'قفل الجهاز فوراً',
                            type: child.isLocked
                                ? SgButtonType.secondary
                                : SgButtonType.danger,
                            icon: child.isLocked ? Icons.lock_open : Icons.lock,
                            isLoading: state.isActionInProgress,
                            onPressed: () {
                              context.read<DashboardCubit>().toggleChildLock(
                                    childId: child.id,
                                    deviceId: 'device_demo_1',
                                    currentLockState: child.isLocked,
                                  );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // زر توليد كود ربط الجهاز
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.qr_code, size: 20),
                          label: const Text('توليد رمز ربط جهاز الطفل (Pairing Code)'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<PairingCodeCubit>(
                                  create: (_) => sl<PairingCodeCubit>(),
                                  child: GeneratePairingCodeScreen(child: child),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        // زر فتح مركز التحكم الفوري بالأوامر
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.settings_remote, size: 20),
                          label: const Text('مركز التحكم الفوري عن بُعد (FCM Commands)'),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (_) => BlocProvider<CommandCubit>(
                                create: (_) => sl<CommandCubit>(),
                                child: RemoteControlSheet(child: child),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style:
              const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
