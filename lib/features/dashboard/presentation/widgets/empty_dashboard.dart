import 'package:flutter/material.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_button.dart';

class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({super.key, this.onUpload});

  final VoidCallback? onUpload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: 24),
            Text(
              'No documents yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first PDF to get started',
              style: TextStyle(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: onUpload,
              label: 'Upload PDF',
              icon: Icons.upload_file,
              isExpanded: false,
            ),
          ],
        ),
      ),
    );
  }
}
