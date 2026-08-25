import 'package:flutter/material.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/viewer_provider.dart';

class AnnotationToolbar extends StatelessWidget {
  const AnnotationToolbar({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.onUndo,
    required this.onRedo,
    required this.onAddNote,
    this.canUndo = false,
    this.canRedo = false,
  });

  final String selectedColor;
  final ValueChanged<String> onColorChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onAddNote;
  final bool canUndo;
  final bool canRedo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: AppColors.lightTextTertiary.withAlpha(50))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Color picker
            ...highlightColors.map((color) => GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _parseColor(color),
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                  ),
                )),
            const Spacer(),
            // Undo
            IconButton(
              onPressed: canUndo ? onUndo : null,
              icon: const Icon(Icons.undo, size: 20),
              tooltip: 'Undo',
            ),
            // Redo
            IconButton(
              onPressed: canRedo ? onRedo : null,
              icon: const Icon(Icons.redo, size: 20),
              tooltip: 'Redo',
            ),
            const SizedBox(width: 4),
            // Add note
            IconButton(
              onPressed: onAddNote,
              icon: const Icon(Icons.sticky_note_2_outlined, size: 20),
              tooltip: 'Add sticky note',
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
