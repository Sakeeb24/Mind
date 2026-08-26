import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/mindspace_components.dart';
import 'package:mindspace/features/document_viewer/domain/entities/canvas_card.dart';

class CanvasCardWidget extends StatefulWidget {
  const CanvasCardWidget({
    super.key,
    required this.card,
    required this.isSelected,
    required this.isConnectingTarget,
    required this.isAiProcessing,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onJumpToPage,
    required this.onExplainAi,
    required this.onToggleConnect,
    required this.onDelete,
    required this.onEditContent,
    required this.onChangeColor,
  });

  final CanvasCard card;
  final bool isSelected;
  final bool isConnectingTarget;
  final bool isAiProcessing;
  final VoidCallback onTap;
  final void Function(double dx, double dy) onDragUpdate;
  final VoidCallback onDragEnd;
  final void Function(int page) onJumpToPage;
  final VoidCallback onExplainAi;
  final VoidCallback onToggleConnect;
  final VoidCallback onDelete;
  final void Function(String newContent) onEditContent;
  final void Function(String newColor) onChangeColor;

  @override
  State<CanvasCardWidget> createState() => _CanvasCardWidgetState();
}

class _CanvasCardWidgetState extends State<CanvasCardWidget> {
  void _showEditDialog() {
    final controller = TextEditingController(text: widget.card.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit ${widget.card.title ?? "Card"}',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: GoogleFonts.plusJakartaSans(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter card content...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                widget.onEditContent(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Color _getCardAccentColor(CanvasCardType type) {
    switch (type) {
      case CanvasCardType.textExcerpt:
        return AppColors.cyanGlow;
      case CanvasCardType.stickyNote:
        return AppColors.amberGold;
      case CanvasCardType.aiSummary:
        return AppColors.electricIndigo;
      case CanvasCardType.conceptCard:
        return AppColors.success;
    }
  }

  IconData _getCardIcon(CanvasCardType type) {
    switch (type) {
      case CanvasCardType.textExcerpt:
        return Icons.format_quote_rounded;
      case CanvasCardType.stickyNote:
        return Icons.sticky_note_2_rounded;
      case CanvasCardType.aiSummary:
        return Icons.auto_awesome;
      case CanvasCardType.conceptCard:
        return Icons.psychology_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getCardAccentColor(widget.card.type);

    return Positioned(
      left: widget.card.posX,
      top: widget.card.posY,
      child: GestureDetector(
        onTap: widget.onTap,
        onPanUpdate: (details) {
          widget.onDragUpdate(details.delta.dx, details.delta.dy);
        },
        onPanEnd: (_) => widget.onDragEnd(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.card.width,
          decoration: BoxDecoration(
            color: isDark ? AppColors.navySlate : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isConnectingTarget
                  ? AppColors.error
                  : widget.isSelected
                      ? accentColor
                      : (isDark ? AppColors.whisperBorder : AppColors.lightDivider),
              width: widget.isSelected || widget.isConnectingTarget ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? accentColor.withAlpha(isDark ? 80 : 50)
                    : Colors.black.withAlpha(isDark ? 50 : 15),
                blurRadius: widget.isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceContainerLow
                      : AppColors.lightSurfaceVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Type Icon with accent background
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(isDark ? 35 : 20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getCardIcon(widget.card.type),
                        size: 13,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Title
                    Expanded(
                      child: Text(
                        widget.card.title ?? 'Study Card',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    // Coordinate / Page Link Badge (`p.1 ↗`)
                    InkWell(
                      onTap: () => widget.onJumpToPage(widget.card.pageNumber),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(isDark ? 25 : 15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: accentColor.withAlpha(60),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'p.${widget.card.pageNumber}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.arrow_outward_rounded, size: 9, color: accentColor),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    // Edit button
                    InkWell(
                      onTap: _showEditDialog,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(width: 2),

                    // Delete button
                    InkWell(
                      onTap: widget.onDelete,
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.card.content,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // AI Insight Box (if generated)
              if (widget.card.aiExplanation != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: MindSpaceAiInsight(
                    text: widget.card.aiExplanation!,
                    title: '✦ AI Insight',
                  ),
                ),

              // Bottom Action Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Row(
                  children: [
                    // AI Explain Pill CTA
                    MindSpaceAiExplainButton(
                      isProcessing: widget.isAiProcessing,
                      onTap: widget.onExplainAi,
                    ),

                    const Spacer(),

                    // Connect / Link Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onToggleConnect,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.card.connectedCardIds.isNotEmpty
                                ? AppColors.primary.withAlpha(30)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hub_outlined,
                                size: 12,
                                color: widget.card.connectedCardIds.isNotEmpty
                                    ? AppColors.primary
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                              if (widget.card.connectedCardIds.isNotEmpty) ...[
                                const SizedBox(width: 3),
                                Text(
                                  '${widget.card.connectedCardIds.length}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
