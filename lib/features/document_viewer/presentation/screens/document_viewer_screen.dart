import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/viewer_provider.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/annotation_toolbar.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/sticky_note_editor.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  const DocumentViewerScreen({super.key, required this.document});
  final Document document;

  @override
  ConsumerState<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends ConsumerState<DocumentViewerScreen> {
  int _currentPage = 1;
  final int _totalPages = 10; // placeholder
  bool _showAnnotations = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      try { ref.read(annotationProvider.notifier).loadAnnotations(widget.document.id); } catch (_) {}
    });
  }

  void _showStickyNoteEditor({StickyNote? existingNote}) {
    final isNew = existingNote == null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StickyNoteEditor(
        initialContent: existingNote?.content ?? '',
        onSave: (content) {
          if (isNew) {
            final note = StickyNote(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              documentId: widget.document.id,
              pageNumber: _currentPage,
              xPosition: 0.5,
              yPosition: 0.5,
              content: content,
              createdAt: DateTime.now(),
            );
            ref.read(annotationProvider.notifier).addStickyNote(note);
          } else {
            ref.read(annotationProvider.notifier).updateStickyNote(
              existingNote.copyWith(content: content),
            );
          }
        },
        onDelete: existingNote != null
            ? () {
                ref.read(annotationProvider.notifier).deleteStickyNote(existingNote.id);
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final annotationState = ref.watch(annotationProvider);
    final pageHighlights = annotationState.highlights
        .where((h) => h.pageNumber == _currentPage)
        .toList();
    final pageNotes = annotationState.stickyNotes
        .where((n) => n.pageNumber == _currentPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(_showAnnotations ? Icons.close : Icons.list_alt),
            onPressed: () => setState(() => _showAnnotations = !_showAnnotations),
            tooltip: _showAnnotations ? 'Close annotations' : 'View annotations',
          ),
        ],
      ),
      body: _showAnnotations
          ? _buildAnnotationList(annotationState)
          : Column(
              children: [
                // PDF page placeholder
                Expanded(
                  child: GestureDetector(
                    onLongPress: () => _showStickyNoteEditor(),
                    child: Stack(
                      children: [
                        // Page content placeholder
                        Center(
                          child: Container(
                            width: 300,
                            constraints: const BoxConstraints(maxHeight: 450),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Page $_currentPage',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'PDF content would render here using pdfx.',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Long-press to add a sticky note. Select text to highlight.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Highlight indicators
                        if (pageHighlights.isNotEmpty)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${pageHighlights.length} highlight${pageHighlights.length == 1 ? '' : 's'}',
                                style: TextStyle(fontSize: 11, color: AppColors.primary),
                              ),
                            ),
                          ),
                        // Sticky note pins
                        for (final note in pageNotes)
                          Positioned(
                            left: 300 * note.xPosition,
                            top: 450 * note.yPosition,
                            child: GestureDetector(
                              onTap: () => _showStickyNoteEditor(existingNote: note),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 4)],
                                ),
                                child: const Icon(Icons.sticky_note_2, size: 20, color: Colors.amber),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Page navigation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'Previous page',
                      ),
                      Text('$_currentPage\u00a0/\u00a0$_totalPages'),
                      IconButton(
                        onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Next page',
                      ),
                    ],
                  ),
                ),
                // Annotation toolbar
                AnnotationToolbar(
                  selectedColor: annotationState.selectedColor,
                  onColorChanged: (c) => ref.read(annotationProvider.notifier).setColor(c),
                  onUndo: () => ref.read(annotationProvider.notifier).undo(),
                  onRedo: () => ref.read(annotationProvider.notifier).redo(),
                  onAddNote: () => _showStickyNoteEditor(),
                  canUndo: annotationState.undoStack.isNotEmpty,
                  canRedo: annotationState.redoStack.isNotEmpty,
                ),
              ],
            ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  Widget _buildAnnotationList(AnnotationState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.highlights.isNotEmpty) ...[
          Text('Highlights', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...state.highlights.map((h) => ListTile(
                leading:                        CircleAvatar(
                          radius: 8,
                          backgroundColor: _parseColor(h.color),
                        ),
                title: Text(h.selectedText, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('Page ${h.pageNumber}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => ref.read(annotationProvider.notifier).deleteHighlight(h.id),
                ),
              )),
          const SizedBox(height: 16),
        ],
        if (state.stickyNotes.isNotEmpty) ...[
          Text('Sticky Notes', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...state.stickyNotes.map((n) => ListTile(
                leading: const Icon(Icons.sticky_note_2, color: Colors.amber),
                title: Text(n.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('Page ${n.pageNumber}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => ref.read(annotationProvider.notifier).deleteStickyNote(n.id),
                ),
              )),
        ],
        if (state.highlights.isEmpty && state.stickyNotes.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No annotations yet'),
            ),
          ),
      ],
    );
  }
}
