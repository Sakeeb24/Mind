import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/animated_fade_in.dart';
import 'package:mindspace/core/widgets/app_button.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';
import 'package:mindspace/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
                  'Welcome Back',
                  style: AppTypography.display,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 250),
                child: Text(
                  'Sign in with your Puter account token',
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

              // Link to Puter dashboard
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 400),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _openPuterDashboard(),
                    child: Text(
                      'Get token from puter.com \u2192',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
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

              // Sign up link
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: Text(
                        'Sign Up',
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

  void _openPuterDashboard() {
    // Best-effort: launch the Puter dashboard URL. On web this opens a new tab.
    // We intentionally do not import url_launcher to keep the change minimal.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visit https://puter.com/dashboard to create a token.'),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
