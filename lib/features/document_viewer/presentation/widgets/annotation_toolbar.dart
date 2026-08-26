import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    this.onSummarize,
    this.onAskAi,
    this.onExtractExcerpt,
    this.noteCount = 0,
    this.canUndo = false,
    this.canRedo = false,
  });

  final String selectedColor;
  final ValueChanged<String> onColorChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onAddNote;
  final VoidCallback? onSummarize;
  final VoidCallback? onAskAi;
  final VoidCallback? onExtractExcerpt;
  final int noteCount;
  final bool canUndo;
  final bool canRedo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xE6131B2E) : Colors.white.withAlpha(240),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
            width: 1,
          ),
        ),
        boxShadow: AppDecorations.softShadow,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Color Picker Dots
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: highlightColors.map((color) {
                    final isSelected = selectedColor == color;
                    final parsedColor = _parseColor(color);
                    return GestureDetector(
                      onTap: () => onColorChanged(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: isSelected ? 22 : 18,
                        height: isSelected ? 22 : 18,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: parsedColor,
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: parsedColor.withAlpha(160),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.black.withAlpha(30),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: isDark ? AppColors.whisperBorder : AppColors.lightDivider),
              const SizedBox(width: 8),

              // 2. Sticky Note Tool with Badge
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAddNote,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sticky_note_2_outlined, size: 16, color: AppColors.amberGold),
                        if (noteCount > 0) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$noteCount',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: isDark ? AppColors.whisperBorder : AppColors.lightDivider),
              const SizedBox(width: 8),

              // 3. Quick Action Pills: Summarize, Ask AI, Extract Excerpt
              if (onSummarize != null)
                _buildActionPill(
                  label: 'Summarize',
                  icon: Icons.summarize_outlined,
                  onTap: onSummarize!,
                  isDark: isDark,
                ),
              if (onAskAi != null) ...[
                const SizedBox(width: 6),
                _buildActionPill(
                  label: 'Ask AI',
                  icon: Icons.auto_awesome,
                  isHighlighted: true,
                  onTap: onAskAi!,
                  isDark: isDark,
                ),
              ],
              if (onExtractExcerpt != null) ...[
                const SizedBox(width: 6),
                _buildActionPill(
                  label: 'Excerpt',
                  icon: Icons.format_quote_rounded,
                  onTap: onExtractExcerpt!,
                  isDark: isDark,
                ),
              ],

              const SizedBox(width: 8),
              Container(width: 1, height: 20, color: isDark ? AppColors.whisperBorder : AppColors.lightDivider),
              const SizedBox(width: 8),

              // 4. Undo / Redo
              _buildIconButton(
                icon: Icons.undo,
                tooltip: 'Undo',
                enabled: canUndo,
                onTap: onUndo,
                isDark: isDark,
              ),
              const SizedBox(width: 4),
              _buildIconButton(
                icon: Icons.redo,
                tooltip: 'Redo',
                enabled: canRedo,
                onTap: onRedo,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionPill({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool isHighlighted = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.primary.withAlpha(isDark ? 50 : 25)
                : (isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.primary
                  : (isDark ? AppColors.whisperBorder : AppColors.lightDivider),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: isHighlighted ? AppColors.cyanGlow : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted ? AppColors.cyanGlow : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required bool enabled,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return IconButton(
      icon: Icon(icon, size: 16),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      color: enabled
          ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
          : (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
      onPressed: enabled ? onTap : null,
    );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
