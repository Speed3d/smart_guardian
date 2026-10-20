import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/manage_child_cubit.dart';
import '../cubit/manage_child_state.dart';

// ============================================================================
// 📌 شاشة إضافة أو تعديل بيانات الطفل (Add / Edit Child Screen)
// ----------------------------------------------------------------------------
// تمكن الأب من تسجيل طفل جديد وتحديد الحد الأقصى لساعات استخدام الهاتف يومياً.
// ============================================================================

class AddEditChildScreen extends StatefulWidget {
  final String parentId;

  const AddEditChildScreen({
    super.key,
    required this.parentId,
  });

  @override
  State<AddEditChildScreen> createState() => _AddEditChildScreenState();
}

class _AddEditChildScreenState extends State<AddEditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  double _dailyLimitHours = 2.0; // ساعتان افتراضياً

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final age = int.tryParse(_ageController.text) ?? 10;
      final limitMinutes = (_dailyLimitHours * 60).round();

      context.read<ManageChildCubit>().addNewChild(
            parentId: widget.parentId,
            name: _nameController.text,
            age: age,
            dailyLimitMinutes: limitMinutes,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طفل جديد'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<ManageChildCubit, ManageChildState>(
            listener: (context, state) {
              if (state.status == ManageChildStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت إضافة الطفل بنجاح!'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
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
              final isLoading = state.status == ManageChildStatus.loading;

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // أيقونة بروفايل الطفل
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.child_care,
                            size: 48, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // حقل اسم الطفل
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الطفل',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال اسم الطفل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // حقل العمر
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'العمر',
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'يرجى إدخال عمر صحيح بالأرقام';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // شريط تمرير لتحديد الحد اليومي بالساعات
                    SgCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'الحد اليومي لوقت الشاشة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                AppDateUtils.formatDurationMinutes(
                                    (_dailyLimitHours * 60).round()),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Slider(
                            value: _dailyLimitHours,
                            min: 0.5,
                            max: 8.0,
                            divisions: 15,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() => _dailyLimitHours = val);
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('30 دقيقة',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.lightTextSecondary)),
                              Text('8 ساعات',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.lightTextSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // زر حفظ الطفل
                    SgButton(
                      label: 'حفظ ملف الطفل',
                      isLoading: isLoading,
                      onPressed: _onSavePressed,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
