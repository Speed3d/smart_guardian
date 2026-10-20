import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/pairing_code_cubit.dart';
import '../cubit/pairing_code_state.dart';

// ============================================================================
// 📌 شاشة توليد كود ربط جهاز الطفل (Generate Pairing Code Screen)
// ----------------------------------------------------------------------------
// تعرض للأب كوداً رقمياً مكوناً من 6 أرقام يطلبه تطبيق الطفل لاكتمال الاقتران.
// ============================================================================

class GeneratePairingCodeScreen extends StatefulWidget {
  final ChildEntity child;

  const GeneratePairingCodeScreen({
    super.key,
    required this.child,
  });

  @override
  State<GeneratePairingCodeScreen> createState() =>
      _GeneratePairingCodeScreenState();
}

class _GeneratePairingCodeScreenState extends State<GeneratePairingCodeScreen> {
  @override
  void initState() {
    super.initState();
    // توليد الكود فور فتح الشاشة
    context.read<PairingCodeCubit>().generateCode(
          parentId: widget.child.parentId,
          childId: widget.child.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ربط جهاز ${widget.child.name}'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<PairingCodeCubit, PairingCodeState>(
            builder: (context, state) {
              if (state.status == PairingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == PairingStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.danger),
                      const SizedBox(height: 16),
                      Text(state.errorMessage ?? 'حدث خطأ أثناء إنشاء الكود'),
                      const SizedBox(height: 16),
                      SgButton(
                        label: 'إعادة المحاولة',
                        onPressed: () {
                          context.read<PairingCodeCubit>().generateCode(
                                parentId: widget.child.parentId,
                                childId: widget.child.id,
                              );
                        },
                      ),
                    ],
                  ),
                );
              }

              final code = state.pairingCode?.code ?? '------';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'أدخل هذا الرمز في هاتف طفلك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'قم بتثبيت تطبيق Smart Guardian Child على جهاز الطفل، وافتح التطبيق وأدخل هذا الرمز:',
                    style: TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // مستطيل عرض الكود الرقمي بوضوح
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 18, color: AppColors.warning),
                      SizedBox(width: 6),
                      Text(
                        'ينتهي الكود بعد ${AppConstants.pairingCodeValidityMinutes} دقائق',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // زر إعادة التوليد
                  SgButton(
                    label: 'توليد رمز جديد',
                    type: SgButtonType.secondary,
                    icon: Icons.refresh,
                    onPressed: () {
                      context.read<PairingCodeCubit>().generateCode(
                            parentId: widget.child.parentId,
                            childId: widget.child.id,
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
