import 'package:flutter/material.dart';
import 'package:mindspace/config/theme.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    );
  }
}
