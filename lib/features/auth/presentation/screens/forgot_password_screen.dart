import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/utils/validators.dart';
import 'package:mindspace/core/widgets/animated_fade_in.dart';
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

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).sendPasswordResetEmail(_emailController.text);
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Icon
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 100),
                child: const Icon(Icons.lock_reset, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  _emailSent ? 'Check Your Email' : 'Reset Password',
                  style: AppTypography.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 250),
                child: Text(
                  _emailSent
                      ? 'We sent a password reset link to ${_emailController.text}'
                      : "Enter your email and we'll send you a reset link",
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.lightTextSecondary),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              if (!_emailSent) ...[
                // Email form
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 350),
                  child: Form(
                    key: _formKey,
                    child: AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: Validators.email,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Reset button
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 450),
                  child: AppButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    label: 'Send Reset Link',
                    isLoading: _isLoading,
                    isExpanded: true,
                  ),
                ),
              ] else ...[
                // Success state
                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 350),
                  child: AppButton(
                    onPressed: () => context.go('/login'),
                    label: 'Back to Sign In',
                    isExpanded: true,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                AnimatedFadeIn(
                  delay: const Duration(milliseconds: 450),
                  child: TextButton(
                    onPressed: () => setState(() => _emailSent = false),
                    child: Text(
                      'Try a different email',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Back to login
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Sign In',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
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
}
