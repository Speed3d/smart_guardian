import 'package:flutter/material.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';

/// ============================================================================
/// 📌 نقطة انطلاق تطبيق الأب (Smart Guardian Parent)
/// ----------------------------------------------------------------------------
/// الواجهة الرئيسية لولي الأمر لمتابعة الأطفال وإرسال أوامر القفل وإدارة الأمان.
/// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartGuardianParentApp());
}

class SmartGuardianParentApp extends StatelessWidget {
  const SmartGuardianParentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ParentDashboardScreen(),
    );
  }
}

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  bool _isDeviceLocked = false;
  bool _isLoading = false;

  /// تبديل حالة قفل جهاز الطفل تجريبياً
  void _toggleLock() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isDeviceLocked = !_isDeviceLocked;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDeviceLocked
                ? 'تم إرسال أمر قفل الجهاز فوراً عبر FCM'
                : 'تم فك قفل الجهاز بنجاح',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: _isDeviceLocked ? AppColors.danger : AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأب - Smart Guardian'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة ترحيبية وإحصائية
              SgCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // بطاقة الطفل ومؤشر الوقت المتبقي
              SgCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'جهاز: أحمد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isDeviceLocked
                                ? AppColors.danger.withAlpha(25)
                                : AppColors.success.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isDeviceLocked ? 'الجهاز مقفل 🔒' : 'نشط الآن 🟢',
                            style: TextStyle(
                              color: _isDeviceLocked ? AppColors.danger : AppColors.success,
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
                          value: AppDateUtils.formatDurationMinutes(75),
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
                    // زر التحكم بالقفل
                    SizedBox(
                      width: double.infinity,
                      child: SgButton(
                        label: _isDeviceLocked ? 'إلغاء قفل الجهاز' : 'قفل الجهاز فوراً',
                        type: _isDeviceLocked ? SgButtonType.secondary : SgButtonType.danger,
                        icon: _isDeviceLocked ? Icons.lock_open : Icons.lock,
                        isLoading: _isLoading,
                        onPressed: _toggleLock,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
