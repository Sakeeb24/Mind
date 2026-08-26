import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/services/file_upload_service.dart';
import 'package:mindspace/core/widgets/mindspace_components.dart';
import 'package:mindspace/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/document_card.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/folder_card.dart';
import 'package:mindspace/features/document_viewer/presentation/screens/document_viewer_screen.dart';
import 'package:mindspace/features/document_viewer/presentation/widgets/study_features_dialogs.dart';
import 'package:mindspace/features/folders/domain/entities/folder.dart';
import 'package:mindspace/features/folders/presentation/providers/folder_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isGridView = true;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
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
        title: Text(
          'Create Folder',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Folder Name',
            hintText: 'e.g. Machine Learning, Neuroscience',
            prefixIcon: Icon(Icons.folder_outlined),
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
                ref.read(folderProvider.notifier).addFolder(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpload() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Show Stitch upload progress modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => _UploadProgressDialog(
        isDark: isDark,
        onDocumentReady: (doc) {
          ref.read(dashboardProvider.notifier).addDocument(doc);
          Navigator.pop(dialogCtx);

          // Automatically open the document workspace
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DocumentViewerScreen(document: doc),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final folders = ref.watch(folderProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedFolderName = dashboardState.selectedFolderId != null
        ? folders
            .firstWhere(
              (f) => f.id == dashboardState.selectedFolderId,
              orElse: () => Folder(id: '', name: 'Folder', createdAt: DateTime.now()),
            )
            .name
        : null;

    final totalDocuments = dashboardState.documents.length;
    final filteredDocs = dashboardState.filteredDocuments;

    return Scaffold(
      backgroundColor: isDark ? AppColors.obsidian : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.navySlate : AppColors.lightSurface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: AppColors.cyanGlow, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              selectedFolderName ?? 'MindSpace',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            if (selectedFolderName != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Folder',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          // Remaining Daily AI Queries Badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.amberGold),
                const SizedBox(width: 4),
                Text(
                  '18/20 Queries',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              size: 20,
            ),
            tooltip: _isGridView ? 'Switch to list view' : 'Switch to grid view',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, size: 20),
            tooltip: 'Sort documents',
            onSelected: (option) => ref.read(dashboardProvider.notifier).setSort(option),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortOption.recent, child: Text('Recent')),
              const PopupMenuItem(value: SortOption.name, child: Text('Name')),
              const PopupMenuItem(value: SortOption.dateAdded, child: Text('Date Added')),
              const PopupMenuItem(value: SortOption.size, child: Text('Size')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar & Header Controls
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => ref.read(dashboardProvider.notifier).setSearch(value),
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search documents',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceContainerHigh : Colors.black12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '⌘K',
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _handleUpload,
                  icon: const Icon(Icons.upload_file_rounded, size: 18),
                  label: const Text('Upload PDF'),
                ),
              ],
            ),
          ),

          // Quick Study Stats Row (Stitch Specs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: MindSpaceStudyMetric(
                    label: 'Documents',
                    value: '$totalDocuments',
                    icon: Icons.description_outlined,
                    accentColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: MindSpaceStudyMetric(
                    label: 'Highlights',
                    value: '148',
                    icon: Icons.edit_note_outlined,
                    accentColor: AppColors.cyanGlow,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: MindSpaceStudyMetric(
                    label: 'Streak',
                    value: '7 Days',
                    icon: Icons.local_fire_department_outlined,
                    accentColor: AppColors.amberGold,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: MindSpaceStudyMetric(
                    label: 'Decks',
                    value: '4',
                    icon: Icons.style_outlined,
                    accentColor: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          // Folder breadcrumb (if inside folder)
          if (dashboardState.selectedFolderId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => ref.read(dashboardProvider.notifier).setFolder(null),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: Text(
                    'All Documents',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

          // Main Study Content Area
          Expanded(
            child: filteredDocs.isEmpty && folders.isEmpty
                ? EmptyDashboard(onUpload: _handleUpload)
                : CustomScrollView(
                    slivers: [
                      // Folders Grid (if any)
                      if (folders.isNotEmpty && dashboardState.selectedFolderId == null) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Folders',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _showCreateFolderDialog,
                                  icon: const Icon(Icons.add, size: 14),
                                  label: const Text('New Folder', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisExtent: 90,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final folder = folders[index];
                                return FolderCard(
                                  folder: folder,
                                  documentCount: dashboardState.documents
                                      .where((d) => d.folderId == folder.id)
                                      .length,
                                  onTap: () => ref.read(dashboardProvider.notifier).setFolder(folder.id),
                                );
                              },
                              childCount: folders.length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      ],

                      // Documents Grid / List
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Study Library (${filteredDocs.length})',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (_isGridView)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 320,
                              mainAxisExtent: 240,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final doc = filteredDocs[index];
                                return DocumentCard(
                                  document: doc,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DocumentViewerScreen(document: doc),
                                      ),
                                    );
                                  },
                                  onSummaryTap: () {
                                    StudyFeaturesDialogs.showSummaryDialog(
                                      context: context,
                                      ref: ref,
                                      document: doc,
                                    );
                                  },
                                  onChatTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AiChatScreen(document: doc),
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: filteredDocs.length,
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final doc = filteredDocs[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.navySlate : AppColors.lightSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.cyanGlow),
                                    title: Text(doc.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                                    subtitle: Text('${doc.pageCount} pages · ${doc.fileSizeFormatted}'),
                                    trailing: const Icon(Icons.chevron_right_rounded),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DocumentViewerScreen(document: doc),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: filteredDocs.length,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'create_folder_fab',
            onPressed: _showCreateFolderDialog,
            tooltip: 'Create Folder',
            backgroundColor: isDark ? AppColors.surfaceContainerHigh : AppColors.lightSurface,
            child: const Icon(Icons.create_new_folder_outlined, color: AppColors.cyanGlow),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'upload_pdf_fab',
            onPressed: _handleUpload,
            tooltip: 'Upload Document',
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// STITCH UPLOAD PROGRESS DIALOG
// ────────────────────────────────────────────────────────────
class _UploadProgressDialog extends StatefulWidget {
  const _UploadProgressDialog({
    required this.isDark,
    required this.onDocumentReady,
  });

  final bool isDark;
  final ValueChanged<Document> onDocumentReady;

  @override
  State<_UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<_UploadProgressDialog> {
  String _status = 'Selecting document...';
  double _progress = 0.2;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  Future<void> _startUpload() async {
    try {
      final result = await FileUploadService.pickPdf();
      if (result == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      setState(() {
        _status = 'Parsing PDF structure & pages...';
        _progress = 0.6;
      });

      final doc = await FileUploadService.processUpload(result);

      setState(() {
        _status = 'Finalizing document ingestion...';
        _progress = 1.0;
      });

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        widget.onDocumentReady(doc);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Upload error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDark ? AppColors.navySlate : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: widget.isDark ? AppColors.whisperBorder : AppColors.lightDivider,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(widget.isDark ? 30 : 15),
                shape: BoxShape.circle,
              ),
              child: _error != null
                  ? const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 36)
                  : const Icon(Icons.cloud_upload_outlined, color: AppColors.cyanGlow, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              _error != null ? 'Upload Error' : _status,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _error != null
                    ? AppColors.error
                    : (widget.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_error == null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  color: AppColors.cyanGlow,
                  backgroundColor: widget.isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
