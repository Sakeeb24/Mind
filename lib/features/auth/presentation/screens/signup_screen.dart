import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/animated_fade_in.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool _isLoading = false;
  final _tokenController = TextEditingController();
  bool _obscureToken = true;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _handleTokenSignIn() {
    final token = _tokenController.text.trim();
    if (token.isEmpty) return;
    setState(() => _isLoading = true);
    ref.read(authProvider.notifier).signInWithToken(token);
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
                  'Create a Puter account, then sign in with your token',
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.lightTextSecondary),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Token input field
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _tokenController,
                      label: 'Puter Auth Token',
                      hint: 'Enter your Puter auth token',
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      obscureText: _obscureToken,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) => _handleTokenSignIn(),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          _obscureToken ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscureToken = !_obscureToken),
                        tooltip: _obscureToken ? 'Show token' : 'Hide token',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Primary CTA
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 450),
                child: AppButton(
                  onPressed: _isLoading ? null : _handleTokenSignIn,
                  label: 'Sign In',
                  isLoading: _isLoading,
                  isExpanded: true,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Back to sign in link
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
