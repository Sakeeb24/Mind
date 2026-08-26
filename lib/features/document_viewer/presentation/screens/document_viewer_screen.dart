import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/services/file_upload_service.dart';
import 'package:mindspace/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/document_viewer/domain/entities/sticky_note.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/canvas_provider.dart';
import 'package:mindspace/features/document_viewer/presentation/providers/viewer_provider.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/annotation_toolbar.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/spatial_canvas_view.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/sticky_note_editor.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/study_features_dialogs.dart';

class DocumentViewerScreen extends ConsumerStatefulWidget {
  const DocumentViewerScreen({super.key, required this.document});
  final Document document;

  @override
  ConsumerState<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends ConsumerState<DocumentViewerScreen> {
  PdfController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _showAnnotations = false;
  bool _showCanvas = true;
  bool _showAiAssistant = false;
  bool _isLoadingPdf = true;
  bool _studyMode = true;
  final TextEditingController _pageInputController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _totalPages = widget.document.pageCount > 0 ? widget.document.pageCount : 1;
    _initPdf();
    Future.microtask(() {
      try {
        ref.read(annotationProvider.notifier).loadAnnotations(widget.document.id);
        ref.read(canvasProvider.notifier).loadCards(widget.document.id);
      } catch (_) {}
    });
  }

  Future<void> _initPdf() async {
    try {
      if (kIsWeb) {
        final bytes = FileUploadService.loadWebPdfBytes(widget.document.filePath);
        if (bytes != null) {
          _pdfController = PdfController(
            document: PdfDocument.openData(bytes),
          );
        }
      } else {
        _pdfController = PdfController(
          document: PdfDocument.openFile(widget.document.filePath),
        );
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingPdf = false);
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _pageInputController.dispose();
    super.dispose();
  }

  void _jumpToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
        _pageInputController.text = '$page';
      });
      try {
        _pdfController?.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {}
    }
  }

  void _showExtractExcerptDialog() {
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
            const Icon(Icons.format_quote_rounded, color: AppColors.cyanGlow, size: 20),
            const SizedBox(width: 8),
            Text(
              'Extract Excerpt (Page $_currentPage)',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Topic / Key Concept (Optional)',
                hintText: 'e.g. Scaled Dot-Product Attention',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Excerpt Content',
                hintText: 'Paste or type extracted text, formula, or quote...',
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
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text('Send to Canvas'),
            onPressed: () {
              if (contentController.text.trim().isNotEmpty) {
                ref.read(canvasProvider.notifier).addExcerpt(
                      documentId: widget.document.id,
                      content: contentController.text.trim(),
                      title: titleController.text.trim().isNotEmpty
                          ? titleController.text.trim()
                          : null,
                      pageNumber: _currentPage,
                    );
                Navigator.pop(context);
                if (!_showCanvas) {
                  setState(() => _showCanvas = true);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Excerpt added to Study Workspace Canvas'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showStickyNoteEditor({StickyNote? existingNote}) {
    final isNew = existingNote == null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final annotationState = ref.watch(annotationProvider);
    final isWideScreen = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidian : AppColors.lightBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildStitchTopNavBar(context, isWideScreen),
      ),
      body: Column(
        children: [
          // Quick AI Action Bar
          _buildAiActionBar(),

          // Main Workspace Body
          Expanded(
            child: _showAnnotations
                ? _buildAnnotationList(annotationState)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final showSplitCanvas = isWideScreen && _showCanvas;
                      final showSplitAi = isWideScreen && _showAiAssistant;

                      return Row(
                        children: [
                          // 1. LEFT PANE: PDF Viewer Canvas
                          Expanded(
                            flex: (showSplitCanvas || showSplitAi) ? 6 : 10,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onLongPress: () => _showStickyNoteEditor(),
                                        child: Stack(
                                          children: [
                                            if (_isLoadingPdf)
                                              const Center(
                                                child: CircularProgressIndicator(color: AppColors.cyanGlow),
                                              )
                                            else if (_pdfController != null)
                                              PdfView(
                                                controller: _pdfController!,
                                                onPageChanged: (page) {
                                                  setState(() {
                                                    _currentPage = page;
                                                    _pageInputController.text = '$page';
                                                  });
                                                },
                                                onDocumentLoaded: (doc) =>
                                                    setState(() => _totalPages = doc.pagesCount),
                                              )
                                            else
                                              _buildPdfPlaceholder(),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Floating Stitch Annotation Dock
                                    AnnotationToolbar(
                                      selectedColor: annotationState.selectedColor,
                                      onColorChanged: (c) => ref.read(annotationProvider.notifier).setColor(c),
                                      onUndo: () => ref.read(annotationProvider.notifier).undo(),
                                      onRedo: () => ref.read(annotationProvider.notifier).redo(),
                                      onAddNote: () => _showStickyNoteEditor(),
                                      onSummarize: () => StudyFeaturesDialogs.showSummaryDialog(
                                        context: context,
                                        ref: ref,
                                        document: widget.document,
                                        currentPage: _currentPage,
                                      ),
                                      onAskAi: () {
                                        if (isWideScreen) {
                                          setState(() => _showAiAssistant = !_showAiAssistant);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AiChatScreen(document: widget.document),
                                            ),
                                          );
                                        }
                                      },
                                      onExtractExcerpt: _showExtractExcerptDialog,
                                      noteCount: annotationState.stickyNotes.length,
                                      canUndo: annotationState.undoStack.isNotEmpty,
                                      canRedo: annotationState.redoStack.isNotEmpty,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 2. RIGHT PANE: Spatial Canvas Workspace
                          if (showSplitCanvas && !_showAiAssistant)
                            Expanded(
                              flex: 5,
                              child: SpatialCanvasView(
                                documentId: widget.document.id,
                                currentPage: _currentPage,
                                onJumpToPage: _jumpToPage,
                                onAddExcerptRequest: _showExtractExcerptDialog,
                              ),
                            ),

                          // 3. RIGHT PANE: Embedded AI Chat Studio (if active)
                          if (showSplitAi)
                            Expanded(
                              flex: 5,
                              child: AiChatScreen(document: widget.document),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      // Mobile floating action drawer trigger
      floatingActionButton: (!isWideScreen && !_showCanvas)
          ? FloatingActionButton(
              backgroundColor: AppColors.electricIndigo,
              child: const Icon(Icons.dashboard_customize_outlined),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.obsidian : AppColors.lightBackground,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SpatialCanvasView(
                      documentId: widget.document.id,
                      currentPage: _currentPage,
                      onJumpToPage: (p) {
                        Navigator.pop(context);
                        _jumpToPage(p);
                      },
                      onAddExcerptRequest: () {
                        Navigator.pop(context);
                        _showExtractExcerptDialog();
                      },
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildStitchTopNavBar(BuildContext context, bool isWideScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.navySlate : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                tooltip: 'Back to Library',
                onPressed: () => Navigator.pop(context),
              ),

              // Brand & Document Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.cyanGlow, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'MindSpace AI',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 16, color: isDark ? AppColors.whisperBorder : AppColors.lightDivider),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(
                      widget.document.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Center Document Controls (Page Navigation)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                      onPressed: _currentPage > 1 ? () => _jumpToPage(_currentPage - 1) : null,
                    ),
                    Text(
                      'Page $_currentPage of $_totalPages',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                      onPressed: _currentPage < _totalPages ? () => _jumpToPage(_currentPage + 1) : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Study Mode Toggle
              if (isWideScreen)
                TextButton.icon(
                  icon: Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: _studyMode ? AppColors.cyanGlow : AppColors.darkTextTertiary,
                  ),
                  label: Text(
                    'Study Mode',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _studyMode ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary) : AppColors.darkTextTertiary,
                    ),
                  ),
                  onPressed: () => setState(() => _studyMode = !_studyMode),
                ),

              // Canvas Workspace Toggle
              IconButton(
                icon: Icon(
                  _showCanvas ? Icons.view_sidebar_rounded : Icons.view_sidebar_outlined,
                  size: 20,
                  color: _showCanvas ? AppColors.cyanGlow : null,
                ),
                tooltip: _showCanvas ? 'Hide Study Canvas' : 'Show Study Canvas',
                onPressed: () => setState(() {
                  _showCanvas = !_showCanvas;
                  if (_showCanvas) _showAiAssistant = false;
                }),
              ),

              // AI Assistant Studio Toggle
              IconButton(
                icon: Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: _showAiAssistant ? AppColors.cyanGlow : null,
                ),
                tooltip: 'AI Assistant Studio',
                onPressed: () {
                  if (isWideScreen) {
                    setState(() {
                      _showAiAssistant = !_showAiAssistant;
                      if (_showAiAssistant) _showCanvas = false;
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AiChatScreen(document: widget.document),
                      ),
                    );
                  }
                },
              ),

              // Annotations Toggle
              IconButton(
                icon: Icon(_showAnnotations ? Icons.close : Icons.list_alt, size: 20),
                tooltip: _showAnnotations ? 'Close Annotations' : 'View Annotations',
                onPressed: () => setState(() => _showAnnotations = !_showAnnotations),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiActionBar() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerLow : AppColors.lightSurfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
            width: 0.8,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAiActionChip(
            label: '✦ Summarize Doc',
            icon: Icons.summarize_outlined,
            onTap: () => StudyFeaturesDialogs.showSummaryDialog(
              context: context,
              ref: ref,
              document: widget.document,
              currentPage: _currentPage,
            ),
          ),
          const SizedBox(width: 8),
          _buildAiActionChip(
            label: '✦ Key Formulas & Definitions',
            icon: Icons.calculate_outlined,
            onTap: () => StudyFeaturesDialogs.showFormulasDialog(
              context: context,
              ref: ref,
              document: widget.document,
              currentPage: _currentPage,
            ),
          ),
          const SizedBox(width: 8),
          _buildAiActionChip(
            label: '✦ Generate 5 Flashcards',
            icon: Icons.style_outlined,
            onTap: () => StudyFeaturesDialogs.showFlashcardsDialog(
              context: context,
              ref: ref,
              document: widget.document,
            ),
          ),
          const SizedBox(width: 8),
          _buildAiActionChip(
            label: '✦ Quiz Me',
            icon: Icons.quiz_outlined,
            onTap: () => StudyFeaturesDialogs.showQuizDialog(
              context: context,
              ref: ref,
              document: widget.document,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiActionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.navySlate : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppColors.cyanGlow),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.cyanGlow : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 30 : 15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.picture_as_pdf, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              widget.document.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.document.pageCount} pages · ${widget.document.fileSizeFormatted}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnotationList(AnnotationState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.highlights.isNotEmpty) ...[
          Text('Highlights', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...state.highlights.map((h) => ListTile(
                leading: CircleAvatar(
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
          Text('Sticky Notes', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...state.stickyNotes.map((n) => ListTile(
                leading: const Icon(Icons.sticky_note_2, color: AppColors.amberGold),
                title: Text(n.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('Page ${n.pageNumber}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => ref.read(annotationProvider.notifier).deleteStickyNote(n.id),
                ),
              )),
        ],
        if (state.highlights.isEmpty && state.stickyNotes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No annotations yet',
                style: GoogleFonts.plusJakartaSans(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }
}