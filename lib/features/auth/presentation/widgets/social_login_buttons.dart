import 'package:flutter/material.dart';

import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    required this.onGoogleTap,
    this.isLoading = false,
  });

  final VoidCallback onGoogleTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OR divider
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightTextTertiary,
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        // Google button
        AppButton(
          onPressed: isLoading ? null : onGoogleTap,
          label: 'Continue with Google',
          variant: AppButtonVariant.secondary,
          icon: Icons.g_mobiledata,
          isExpanded: true,
        ),
      ],
    );
  }
}
