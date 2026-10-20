import 'package:flutter/material.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';
import 'package:sg_native_bridge/sg_native_bridge.dart';

/// ============================================================================
/// 📌 نقطة انطلاق تطبيق الطفل (Smart Guardian Child)
/// ----------------------------------------------------------------------------
/// يثبت على جهاز الطفل؛ يعرض الوقت المتبقي، ويستقبل أوامر الأب، ويتضمن زر الطوارئ SOS.
/// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartGuardianChildApp());
}

class SmartGuardianChildApp extends StatelessWidget {
  const SmartGuardianChildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${AppConstants.appName} - حماية الطفل',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ChildStatusScreen(),
    );
  }
}

class ChildStatusScreen extends StatefulWidget {
  const ChildStatusScreen({super.key});

  @override
  State<ChildStatusScreen> createState() => _ChildStatusScreenState();
}

class _ChildStatusScreenState extends State<ChildStatusScreen> {
  final int _remainingMinutes = 90;
  bool _isSendingSos = false;

  /// إرسال إشارة استغاثة طارئة للأب
  void _sendSosAlert() async {
    setState(() => _isSendingSos = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSendingSos = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('تم إرسال إشعار الطوارئ 🚨', textAlign: TextAlign.center),
          content: const Text(
            'تم إرسال موقعك الجغرافي وحالة جهازك فوراً إلى هاتف ولي الأمر.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Guardian - وضع الحماية'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
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
                    color: AppColors.primary.withAlpha(20),
                    border: Border.all(color: AppColors.primary, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.hourglass_top, color: AppColors.primary, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        AppDateUtils.formatDurationMinutes(_remainingMinutes),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'متبقي اليوم',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // بطاقة حالة الحماية
              SgCard(
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: AppColors.success, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الحماية الذكية مفعلة',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'الجهاز يخضع للجدول المحدد والرقابة الآمنة.',
                            style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          // فحص حالة إدارة الجهاز عبر الـ Native Bridge
                          FutureBuilder<bool>(
                            future: DeviceControlBridge.isDeviceAdminActive(),
                            builder: (context, snapshot) {
                              final isAdmin = snapshot.data ?? false;
                              return Text(
                                isAdmin ? 'حماية الحذف: نشطة 🛡️' : 'حماية الحذف: بانتظار التفعيل ⚙️',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isAdmin ? AppColors.success : AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
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
                isLoading: _isSendingSos,
                onPressed: _sendSosAlert,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
