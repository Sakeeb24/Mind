import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/animated_fade_in.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/features/auth/presentation/widgets/auth_form.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool _isLoading = false;
  String? _name;
  String? _email;
  String? _password;

  void _handleEmailSignUp() {
    if (_email == null || _password == null) return;
    setState(() => _isLoading = true);
    ref.read(authProvider.notifier).signUpWithEmail(_email!, _password!, displayName: _name);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Logo
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 100),
                child: Semantics(label: 'MindSpace logo', child: const Icon(Icons.menu_book_rounded, size: 72, color: AppColors.primary)),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Create Account',
                  style: AppTypography.display,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 250),
                child: Text(
                  'Start your free study assistant',
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.lightTextSecondary),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Form
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 350),
                child: AuthForm(
                  onChanged: (email, password, name) {
                    _email = email;
                    _password = password;
                    _name = name;
                  },
                  onSubmit: (email, password, _) {
                    _email = email;
                    _password = password;
                    _handleEmailSignUp();
                  },
                  submitLabel: 'Create Account',
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Primary CTA
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 450),
                child: AppButton(
                  onPressed: _isLoading ? null : _handleEmailSignUp,
                  label: 'Create Account',
                  isLoading: _isLoading,
                  isExpanded: true,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign in link
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
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
