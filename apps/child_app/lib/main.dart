import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';

import 'core/di/service_locator.dart';
import 'features/status/presentation/cubit/child_status_cubit.dart';
import 'features/status/presentation/cubit/child_status_state.dart';

// ============================================================================
// 📌 نقطة انطلاق تطبيق الطفل (Smart Guardian Child)
// ----------------------------------------------------------------------------
// يدمج BLoC/Cubit مع قنوات الاتصال الأصلية (Platform Channels) لإدارة الحظر.
// ============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initChildServiceLocator();
  runApp(const SmartGuardianChildApp());
}

class SmartGuardianChildApp extends StatelessWidget {
  const SmartGuardianChildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChildStatusCubit>(
      create: (_) => sl<ChildStatusCubit>()
        ..listenToParentCommands('demo_child_1', 'demo_device_1'),
      child: MaterialApp(
        title: '${AppConstants.appName} - حماية الطفل',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ChildStatusScreen(),
      ),
    );
  }
}

class ChildStatusScreen extends StatelessWidget {
  const ChildStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Guardian - وضع الحماية'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<ChildStatusCubit, ChildStatusState>(
          listener: (context, state) {
            if (state.alertMessage != null) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('تم إرسال إشعار الطوارئ 🚨',
                      textAlign: TextAlign.center),
                  content: Text(
                    state.alertMessage!,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.read<ChildStatusCubit>().clearAlert();
                        Navigator.pop(ctx);
                      },
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // دائرة عرض الوقت المتبقي
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isLocked
                            ? AppColors.danger.withAlpha(20)
                            : AppColors.primary.withAlpha(20),
                        border: Border.all(
                          color: state.isLocked
                              ? AppColors.danger
                              : AppColors.primary,
                          width: 4,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            state.isLocked ? Icons.lock : Icons.hourglass_top,
                            color: state.isLocked
                                ? AppColors.danger
                                : AppColors.primary,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.isLocked
                                ? 'الجهاز مقفل'
                                : AppDateUtils.formatDurationMinutes(
                                    state.remainingMinutes),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: state.isLocked
                                  ? AppColors.danger
                                  : AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            state.isLocked ? 'بأمر من ولي الأمر' : 'متبقي اليوم',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // بطاقة حالة الحماية الأصلية
                  SgCard(
                    child: Row(
                      children: [
                        Icon(
                          state.isLocked ? Icons.lock : Icons.shield,
                          color: state.isLocked
                              ? AppColors.danger
                              : AppColors.success,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.isLocked
                                    ? 'تم تقييد استخدام الجهاز'
                                    : 'الحماية الذكية مفعلة',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.isLocked
                                    ? 'لا يمكن فتح التطبيقات حتى يرفع الأب القفل.'
                                    : 'الجهاز يخضع للجدول المحدد والرقابة الآمنة.',
                                style: const TextStyle(
                                  color: AppColors.lightTextSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.isDeviceAdminActive
                                    ? 'حماية الحذف: نشطة 🛡️'
                                    : 'حماية الحذف: بانتظار التفعيل ⚙️',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: state.isDeviceAdminActive
                                      ? AppColors.success
                                      : AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // زر الطوارئ SOS
                  SgButton(
                    label: 'طلب مساعدة طارئة (SOS)',
                    type: SgButtonType.danger,
                    icon: Icons.emergency,
                    isLoading: state.isSendingSos,
                    onPressed: () {
                      context.read<ChildStatusCubit>().sendSosAlert();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
