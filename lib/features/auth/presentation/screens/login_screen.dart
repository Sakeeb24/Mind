import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';
import 'package:mindspace/features/auth/presentation/widgets/auth_form.dart';
import 'package:mindspace/features/auth/presentation/widgets/social_login_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String? _email;
  String? _password;

  void _handleEmailSignIn() {
    if (_email == null || _password == null) return;
    setState(() => _isLoading = true);
    ref.read(authProvider.notifier).signInWithEmail(_email!, _password!);
  }

  void _handleGoogleSignIn() {
    setState(() => _isLoading = true);
    ref.read(authProvider.notifier).signInWithGoogle();
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
              Semantics(label: 'MindSpace logo', child: const Icon(Icons.menu_book_rounded, size: 72, color: AppColors.primary)),
              const SizedBox(height: AppSpacing.lg),

              // Title — Taste Skill: Bold hierarchy
              Text(
                'Welcome Back',
                style: AppTypography.display,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle — Taste Skill: Calm secondary tone
              Text(
                'Sign in to continue studying',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Form
              AuthForm(
                onSubmit: (email, password, _) {
                  _email = email;
                  _password = password;
                  _handleEmailSignIn();
                },
                submitLabel: 'Sign In',
              ),

              // Forgot password — Taste Skill: Intentional color
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: Text(
                    'Forgot password\u2026',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Primary CTA
              AppButton(
                onPressed: _isLoading ? null : _handleEmailSignIn,
                label: 'Sign In',
                isLoading: _isLoading,
                isExpanded: true,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Social login
              SocialLoginButtons(
                onGoogleTap: _handleGoogleSignIn,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign up link — Taste Skill: Subtle with purpose
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/signup'),
                    child: Text(
                      'Sign Up',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
