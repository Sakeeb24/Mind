import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/utils/validators.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      ref.read(authProvider.notifier).sendPasswordResetEmail(
            _emailController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated && _isLoading) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      } else if (next.status == AuthStatus.error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Failed to send reset email'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _emailSent
              ? Column(
                  children: [
                    const SizedBox(height: 60),
                    const Icon(Icons.mark_email_read_outlined, size: 80, color: AppColors.success),
                    const SizedBox(height: 24),
                    Text(
                      'Check your email',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We sent a password reset link to ${_emailController.text}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightTextSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      onPressed: () => Navigator.of(context).pop(),
                      label: 'Back to Sign In',
                      isExpanded: true,
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      const Icon(Icons.lock_outline, size: 80, color: AppColors.primary),
                      const SizedBox(height: 24),
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your email and we\'ll send you a reset link.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.lightTextSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        label: 'Send Reset Link',
                        isLoading: _isLoading,
                        isExpanded: true,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
