import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../cubit/admin_dashboard_state.dart';

/// ============================================================================
/// 📌 الشاشة الرئيسية للوحة المشرف والدعم الفني (Admin Dashboard Screen)
/// ----------------------------------------------------------------------------
/// واجهة ويب متجاوبة تتضمن شريط تنقل جانبي، بطاقات إحصائيات، جدول العوائل،
/// ومراقبة التكاليف وحصص Firebase لضمان بقائها مجانية/منخفضة التكلفة.
/// ============================================================================

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<AdminDashboardCubit, AdminDashboardState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<AdminDashboardCubit>().clearMessage();
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.danger,
                ),
              );
              context.read<AdminDashboardCubit>().clearMessage();
            }
          },
          builder: (context, state) {
            return Row(
              children: [
                // 1. القائمة الجانبية (Sidebar)
                _buildSidebar(context, state.selectedTab),

                // 2. المحتوى الرئيسي المتغير (Main Content)
                Expanded(
                  child: Column(
                    children: [
                      _buildTopHeader(context),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24.0),
                          child: _buildTabContent(context, state),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// القائمة الجانبية للتنقل
  Widget _buildSidebar(BuildContext context, int selectedTab) {
    return Container(
      width: 250,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // شعار النظام
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, color: AppColors.primary, size: 26),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Smart Guardian',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'لوحة المشرف والدعم الفني',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
          const SizedBox(height: 32),

          // عناصر القائمة
          _buildNavItem(context, 0, 'نظرة عامة (Overview)', Icons.dashboard, selectedTab),
          _buildNavItem(context, 1, 'العوائل والأطفال', Icons.family_restroom, selectedTab),
          _buildNavItem(context, 2, 'الدعم الفني والطوارئ', Icons.support_agent, selectedTab),
          _buildNavItem(context, 3, 'مراقبة تكلفة Firebase', Icons.analytics, selectedTab),

          const Spacer(),
          // حالة النظام
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الخوادم تعمل بكفاءة 100%',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, String label, IconData icon, int selectedTab) {
    final isSelected = selectedTab == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.read<AdminDashboardCubit>().setTab(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : const Color(0xFF94A3B8), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// الشريط العلوي
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'منظومة الإدارة المركزية والرقابة الأبوية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'حالة النظام: نشط ومتصل 🟢',
                  style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text('AD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// محتوى التبويب النشط
  Widget _buildTabContent(BuildContext context, AdminDashboardState state) {
    switch (state.selectedTab) {
      case 0:
        return _buildOverviewTab(context, state);
      case 1:
        return _buildFamiliesTab(context, state);
      case 2:
        return _buildEmergencySupportTab(context, state);
      case 3:
        return _buildFirebaseQuotaTab(context, state);
      default:
        return _buildOverviewTab(context, state);
    }
  }

  /// 1. تبويب النظرة العامة
  Widget _buildOverviewTab(BuildContext context, AdminDashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // بطاقات المؤشرات (KPIs)
        Row(
          children: [
            _buildKpiCard('إجمالي العوائل', '${state.totalFamilies}', Icons.family_restroom, AppColors.primary),
            const SizedBox(width: 16),
            _buildKpiCard('الأطفال بالحماية', '${state.totalChildren}', Icons.child_care, AppColors.success),
            const SizedBox(width: 16),
            _buildKpiCard('الأجهزة المتصلة', '${state.onlineDevices}', Icons.devices, AppColors.secondary),
            const SizedBox(width: 16),
            _buildKpiCard('تطبيقات مقيدة', '${state.activeBlocks}', Icons.block, AppColors.danger),
          ],
        ),
        const SizedBox(height: 24),

        // بطاقة استهلاك الخطة والتكلفة
        SgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'استهلاك حصص Firebase (Spark Free Tier)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'التكلفة: 0.00\$ 💰',
                    style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: state.firebaseQuotaPercent / 100,
                backgroundColor: Colors.grey[200],
                color: AppColors.primary,
                minHeight: 12,
              ),
              const SizedBox(height: 8),
              Text(
                'تم استهلاك ${state.firebaseQuotaPercent}% من الحد المجاني اليومي لقراءات وكتابات Firestore بفضل نظام المزامنة المجمعة (Batch Syncer).',
                style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // معاينة سريعة للعوائل
        _buildFamiliesTab(context, state),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withAlpha(25),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 2. تبويب العوائل والأطفال
  Widget _buildFamiliesTab(BuildContext context, AdminDashboardState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'قائمة العوائل وحسابات المشتركين',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 280,
                child: TextField(
                  onChanged: (val) => context.read<AdminDashboardCubit>().search(val),
                  decoration: InputDecoration(
                    hintText: 'البحث باسم الوالد أو البريد...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('المعرف')),
                DataColumn(label: Text('اسم الوالد')),
                DataColumn(label: Text('البريد الإلكتروني')),
                DataColumn(label: Text('الخطة')),
                DataColumn(label: Text('عدد الأطفال')),
                DataColumn(label: Text('الحالة')),
              ],
              rows: state.filteredFamilies.map((fam) {
                return DataRow(cells: [
                  DataCell(Text(fam.id)),
                  DataCell(Text(fam.parentName, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(fam.email)),
                  DataCell(Text(fam.plan)),
                  DataCell(Text('${fam.childrenCount}')),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('نشط ✅', style: TextStyle(color: AppColors.success, fontSize: 12)),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. تبويب التدخل الفني ودعم الطوارئ
  Widget _buildEmergencySupportTab(BuildContext context, AdminDashboardState state) {
    final childIdController = TextEditingController(text: 'demo_child_1');
    final deviceIdController = TextEditingController(text: 'demo_device_1');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.support_agent, color: AppColors.danger, size: 28),
              SizedBox(width: 12),
              Text(
                'مركز التدخل الطارئ والدعم الفني (Support Agent Override)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'يسمح لفرق الدعم بالتدخل الفوري لفك قفل جهاز طفل علق في وضع القفل أو تجاوز القيود بناء على طلب مؤكد من ولي الأمر.',
            style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
          ),
          const Divider(height: 32),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: childIdController,
                  decoration: const InputDecoration(
                    labelText: 'معرف الطفل (Child ID)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: deviceIdController,
                  decoration: const InputDecoration(
                    labelText: 'معرف الجهاز (Device ID)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: SgButton(
                  label: 'فك القفل الطارئ للجهاز (Emergency Unlock)',
                  type: SgButtonType.secondary,
                  icon: Icons.lock_open,
                  isLoading: state.isLoading,
                  onPressed: () {
                    context.read<AdminDashboardCubit>().emergencyUnlockDevice(
                          childId: childIdController.text,
                          deviceId: deviceIdController.text,
                        );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SgButton(
                  label: 'قفل طارئ للجهاز (Emergency Lock)',
                  type: SgButtonType.danger,
                  icon: Icons.lock,
                  isLoading: state.isLoading,
                  onPressed: () {
                    context.read<AdminDashboardCubit>().emergencyLockDevice(
                          childId: childIdController.text,
                          deviceId: deviceIdController.text,
                        );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4. تبويب مراقبة تكلفة Firebase
  Widget _buildFirebaseQuotaTab(BuildContext context, AdminDashboardState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تحليل استهلاك الموارد وتكاليف السحابة (Cloud Cost Analysis)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'تقرير دوري يوضح كيف ساهمت معمارية Smart Guardian في إبقاء التكلفة عند صفر دولار.',
            style: TextStyle(color: AppColors.lightTextSecondary),
          ),
          const Divider(height: 32),

          Row(
            children: [
              _buildCostMetricCard('Firestore Reads', '7,200 / 50k', '14.4%', AppColors.primary),
              const SizedBox(width: 12),
              _buildCostMetricCard('Firestore Writes', '3,400 / 20k', '17.0%', AppColors.success),
              const SizedBox(width: 12),
              _buildCostMetricCard('FCM Data Messages', 'مجاناً 100%', '0\$', AppColors.secondary),
              const SizedBox(width: 12),
              _buildCostMetricCard('التكلفة الشهرية', '0.00\$', 'مجاناً 🎉', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostMetricCard(String title, String detail, String badge, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                  child: Text(badge, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(detail, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
