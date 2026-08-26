import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/canvas_provider.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/canvas_card_widget.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/ink_link_painter.dart';

class SpatialCanvasView extends ConsumerStatefulWidget {
  const SpatialCanvasView({
    super.key,
    required this.documentId,
    required this.currentPage,
    required this.onJumpToPage,
    required this.onAddExcerptRequest,
  });

  final String documentId;
  final int currentPage;
  final void Function(int page) onJumpToPage;
  final VoidCallback onAddExcerptRequest;

  @override
  ConsumerState<SpatialCanvasView> createState() => _SpatialCanvasViewState();
}

class _SpatialCanvasViewState extends ConsumerState<SpatialCanvasView> {
  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.navySlate : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.sticky_note_2_rounded, color: AppColors.amberGold, size: 20),
            const SizedBox(width: 8),
            Text(
              'Add Study Note (Page ${widget.currentPage})',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Topic / Title (Optional)',
                hintText: 'e.g. Key Concept Note',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Note Content',
                hintText: 'Type your study note or formula explanation...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add Note'),
            onPressed: () {
              if (contentController.text.trim().isNotEmpty) {
                ref.read(canvasProvider.notifier).addStickyNote(
                      documentId: widget.documentId,
                      title: titleController.text.trim().isNotEmpty
                          ? titleController.text.trim()
                          : null,
                      content: contentController.text.trim(),
                      pageNumber: widget.currentPage,
                    );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.obsidian : AppColors.lightBackground,
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          // 1. Subtle Dot Grid Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _CanvasGridPainter(isDark: isDark),
            ),
          ),

          // 2. Ink Link Connection Lines
          Positioned.fill(
            child: CustomPaint(
              painter: InkLinkPainter(
                cards: canvasState.cards,
                selectedCardId: canvasState.selectedCardId,
                isConnectingMode: canvasState.isConnectingMode,
                connectingFromCardId: canvasState.connectingFromCardId,
              ),
            ),
          ),

          // 3. Canvas Cards Stack
          if (canvasState.cards.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withAlpha(60),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.dashboard_customize_outlined,
                        size: 36,
                        color: AppColors.cyanGlow,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Study Workspace Canvas',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Extract excerpts, add notes, and link ideas freely across your document.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: widget.onAddExcerptRequest,
                          icon: const Icon(Icons.format_quote_rounded, size: 16),
                          label: const Text('Add Excerpt'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _showAddNoteDialog,
                          icon: const Icon(Icons.note_add_outlined, size: 16),
                          label: const Text('Add Note'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            ...canvasState.cards.map((card) {
              final isConnecting = canvasState.isConnectingMode &&
                  canvasState.connectingFromCardId != card.id;

              return CanvasCardWidget(
                key: ValueKey(card.id),
                card: card,
                isSelected: canvasState.selectedCardId == card.id,
                isConnectingTarget: isConnecting,
                isAiProcessing: canvasState.isAiProcessingCardId == card.id,
                onTap: () {
                  if (canvasState.isConnectingMode &&
                      canvasState.connectingFromCardId != null) {
                    ref.read(canvasProvider.notifier).toggleConnection(
                          canvasState.connectingFromCardId!,
                          card.id,
                        );
                  } else {
                    ref.read(canvasProvider.notifier).selectCard(card.id);
                  }
                },
                onDragUpdate: (dx, dy) {
                  ref.read(canvasProvider.notifier).updateCardPosition(
                        card.id,
                        card.posX + dx,
                        card.posY + dy,
                      );
                },
                onDragEnd: () {
                  ref.read(canvasProvider.notifier).persistCardPosition(
                        card.id,
                        card.posX,
                        card.posY,
                      );
                },
                onJumpToPage: widget.onJumpToPage,
                onExplainAi: () {
                  ref.read(canvasProvider.notifier).explainCardWithAi(card.id);
                },
                onToggleConnect: () {
                  if (canvasState.isConnectingMode) {
                    ref.read(canvasProvider.notifier).cancelConnecting();
                  } else {
                    ref.read(canvasProvider.notifier).startConnecting(card.id);
                  }
                },
                onDelete: () {
                  ref.read(canvasProvider.notifier).deleteCard(card.id);
                },
                onEditContent: (newContent) {
                  ref.read(canvasProvider.notifier).updateCardContent(card.id, newContent);
                },
                onChangeColor: (newColor) {
                  ref.read(canvasProvider.notifier).updateCardColor(card.id, newColor);
                },
              );
            }),

          // 4. Floating Header Bar on Canvas
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              children: [
                // Canvas Title Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.polyline_rounded, size: 14, color: AppColors.cyanGlow),
                      const SizedBox(width: 6),
                      Text(
                        'Canvas (${canvasState.cards.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Add Excerpt Button
                IconButton.filledTonal(
                  icon: const Icon(Icons.format_quote_rounded, size: 16),
                  tooltip: 'Extract Excerpt',
                  onPressed: widget.onAddExcerptRequest,
                ),
                const SizedBox(width: 6),

                // Add Note Button
                IconButton.filledTonal(
                  icon: const Icon(Icons.note_add_outlined, size: 16),
                  tooltip: 'Add Note',
                  onPressed: _showAddNoteDialog,
                ),
              ],
            ),
          ),

          // 5. Connection Mode Banner (if active)
          if (canvasState.isConnectingMode)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.navySlate,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cyanGlow, width: 1.2),
                  boxShadow: AppDecorations.softShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hub_outlined, color: AppColors.cyanGlow, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tap another card to link or unlink them',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkTextPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.read(canvasProvider.notifier).cancelConnecting(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.cyanGlow,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  const _CanvasGridPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = isDark ? const Color(0x1FFFFFFF) : const Color(0x14000000)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 1.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasGridPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
