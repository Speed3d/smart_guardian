import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/pairing_input_cubit.dart';
import '../cubit/pairing_input_state.dart';

// ============================================================================
// 📌 شاشة إدخال رمز ربط هاتف الطفل (Child Device Pairing Screen)
// ----------------------------------------------------------------------------
// تتيح إدخال رمز الـ 6 أرقام المولد من هاتف الأب لربط الجهاز بالحساب.
// ============================================================================

class PairingScreen extends StatefulWidget {
  final VoidCallback onPairingSuccess;

  const PairingScreen({
    super.key,
    required this.onPairingSuccess,
  });

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _submitCode();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submitCode() {
    final code = _currentCode;
    if (code.length == AppConstants.pairingCodeLength) {
      context.read<PairingInputCubit>().submitPairingCode(
            code: code,
            deviceId: 'child_device_${DateTime.now().millisecondsSinceEpoch}',
            deviceModel: 'Android Phone',
            osVersion: 'Android 14',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ربط جهاز الطفل'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<PairingInputCubit, PairingInputState>(
              listener: (context, state) {
                if (state.status == PairingInputStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم اقتران الجهاز بنجاح! وضع الحماية نشط الآن.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  widget.onPairingSuccess();
                } else if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state.status == PairingInputStatus.loading;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.phonelink_lock,
                      size: 72,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'أدخل رمز الربط الرقمي',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'افتح تطبيق Smart Guardian Parent على هاتف ولي الأمر، واضغط على "توليد رمز ربط" ثم أدخل الـ 6 أرقام هنا:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // مربعات إدخال الـ 6 أرقام (OTP Style)
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 46,
                            height: 56,
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2.5),
                                ),
                              ),
                              onChanged: (val) => _onDigitChanged(index, val),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // زر تأكيد الربط
                    SgButton(
                      label: 'تأكيد واقتران الجهاز',
                      isLoading: isLoading,
                      onPressed: _submitCode,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
