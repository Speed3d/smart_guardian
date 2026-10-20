import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';

import 'core/di/service_locator.dart';
import 'features/auth/presentation/cubit/admin_auth_cubit.dart';
import 'features/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import 'features/dashboard/presentation/views/admin_dashboard_screen.dart';

// ============================================================================
// 📌 نقطة انطلاق لوحة الإدارة والدعم الفني (Smart Guardian Web Admin Portal)
// ----------------------------------------------------------------------------
// تطبيق ويب مخصص لمشرفي النظام وفرق الدعم الفني لمراقبة الأجهزة والتكاليف.
// ============================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAdminServiceLocator();
  runApp(const SmartGuardianAdminApp());
}

class SmartGuardianAdminApp extends StatelessWidget {
  const SmartGuardianAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminAuthCubit>(
          create: (_) => sl<AdminAuthCubit>(),
        ),
        BlocProvider<AdminDashboardCubit>(
          create: (_) => sl<AdminDashboardCubit>(),
        ),
      ],
      child: MaterialApp(
        title: '${AppConstants.appName} - لوحة الإدارة والدعم الفني',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const AdminDashboardScreen(),
      ),
    );
  }
}
