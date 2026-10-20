import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

// ============================================================================
// 📌 شاشة إنشاء حساب جديد لولي الأمر (Register Screen)
// ----------------------------------------------------------------------------
// تمكن الأب أو الأم من تسجيل حساب جديد لإدارة أجهزة الأبناء.
// ============================================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب ولي أمر'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
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
                final isLoading = state.status == AuthStatus.loading;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'انضم إلى Smart Guardian',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'أنشئ حسابك لحماية أطفالك وإدارة وقت الشاشة بأمان.',
                        style: TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // حقل الاسم
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم الكامل',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال اسمك';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // حقل البريد
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'يرجى إدخال بريد إلكتروني صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // حقل كلمة المرور
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // زر إنشاء الحساب
                      SgButton(
                        label: 'إنشاء الحساب',
                        isLoading: isLoading,
                        onPressed: _onRegisterPressed,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
