import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_text_field.dart';
import 'package:mindspace/core/widgets/confirm_dialog.dart';
import 'package:mindspace/features/dashboard/domain/entities/document.dart';
import 'package:mindspace/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/document_card.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/folder_card.dart';
import 'package:mindspace/features/dashboard/presentation/widgets/upload_button.dart';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Folder'),
        content: AppTextField(
          controller: controller,
          label: 'Folder Name',
          prefixIcon: const Icon(Icons.folder),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
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

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload PDF'),
        content: const Text('Select a PDF file from your device. This will open the file picker.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement file_picker integration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File picker integration coming soon')),
              );
            },
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final folders = ref.watch(folderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardState.selectedFolderId != null
            ? folders.firstWhere((f) => f.id == dashboardState.selectedFolderId, orElse: () => Folder(id: '', name: 'Folder', createdAt: DateTime.now())).name
            : 'MindSpace'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) => ref.read(dashboardProvider.notifier).setSort(option),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortOption.recent, child: Text('Recent')),
              const PopupMenuItem(value: SortOption.name, child: Text('Name')),
              const PopupMenuItem(value: SortOption.dateAdded, child: Text('Date Added')),
              const PopupMenuItem(value: SortOption.size, child: Text('Size')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppTextField(
              controller: _searchController,
              label: 'Search documents',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => ref.read(dashboardProvider.notifier).setSearch(value),
            ),
          ),
          // Back to all button if in folder
          if (dashboardState.selectedFolderId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => ref.read(dashboardProvider.notifier).setFolder(null),
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('All Documents'),
                ),
              ),
            ),
          // Content
          Expanded(
            child: dashboardState.filteredDocuments.isEmpty && folders.isEmpty
                ? EmptyDashboard(onUpload: _showUploadDialog)
                : _buildContent(dashboardState, folders),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'folder',
            onPressed: _showCreateFolderDialog,
            backgroundColor: AppColors.lightSurface,
            child: const Icon(Icons.create_new_folder),
          ),
          const SizedBox(height: 8),
          UploadButton(onPressed: _showUploadDialog),
        ],
      ),
    );
  }

  Widget _buildContent(DashboardState state, List<Folder> folders) {
    final docs = state.filteredDocuments;

    return CustomScrollView(
      slivers: [
        // Folders section
        if (folders.isNotEmpty && state.selectedFolderId == null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Folders', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  final count = state.documents.where((d) => d.folderId == folder.id).length;
                  return SizedBox(
                    width: 160,
                    child: FolderCard(
                      folder: folder,
                      documentCount: count,
                      onTap: () => ref.read(dashboardProvider.notifier).setFolder(folder.id),
                      onLongPress: () => _showFolderOptions(folder),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        // Documents header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Documents', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
        // Documents grid or list
        if (docs.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No documents found')),
          )
        else if (_isGridView)
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => DocumentCard(
                  document: docs[index],
                  onTap: () {},
                  onLongPress: () => _showDocumentOptions(docs[index]),
                ),
                childCount: docs.length,
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.error),
                title: Text(docs[index].title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${docs[index].pageCount} pages · ${docs[index].fileSizeFormatted}'),
                onTap: () {},
                onLongPress: () => _showDocumentOptions(docs[index]),
              ),
              childCount: docs.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  void _showDocumentOptions(Document doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Move to folder'),
              onTap: () {
                Navigator.pop(context);
                _showMoveToFolderDialog(doc);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Delete Document',
                    message: 'Delete ${doc.title}?',
                    confirmLabel: 'Delete',
                    isDestructive: true,
                  ),
                );
                if (confirmed == true) {
                  ref.read(dashboardProvider.notifier).deleteDocument(doc.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveToFolderDialog(Document doc) {
    final folders = ref.read(folderProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to folder'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_off),
                title: const Text('No folder'),
                onTap: () {
                  ref.read(dashboardProvider.notifier).moveToFolder(doc.id, null);
                  Navigator.pop(context);
                },
              ),
              ...folders.map((folder) => ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(folder.name),
                    onTap: () {
                      ref.read(dashboardProvider.notifier).moveToFolder(doc.id, folder.id);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showFolderOptions(Folder folder) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                _showRenameFolderDialog(folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Delete Folder',
                    message: 'Delete ${folder.name}? Documents will not be deleted.',
                    confirmLabel: 'Delete',
                    isDestructive: true,
                  ),
                );
                if (confirmed == true) {
                  ref.read(folderProvider.notifier).deleteFolder(folder.id);
                  ref.read(dashboardProvider.notifier).setFolder(null);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameFolderDialog(Folder folder) {
    final controller = TextEditingController(text: folder.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Folder'),
        content: AppTextField(controller: controller, label: 'Folder Name'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(folderProvider.notifier).renameFolder(folder.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
