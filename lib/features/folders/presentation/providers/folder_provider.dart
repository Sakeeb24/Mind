import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mindspace/config/constants.dart';
import 'package:mindspace/features/folders/data/repositories/hive_folder_repository.dart';
import 'package:mindspace/features/folders/domain/entities/folder.dart';
import 'package:mindspace/features/folders/domain/repositories/folder_repository.dart';

/// Provider for the folder repository.
final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final box = Hive.box(AppConstants.foldersBox);
  return HiveFolderRepository(box);
});

/// Folder notifier managing CRUD operations.
class FolderNotifier extends Notifier<List<Folder>> {
  @override
  List<Folder> build() {
    _loadFolders();
    return [];
  }

  Future<void> _loadFolders() async {
    final repo = ref.read(folderRepositoryProvider);
    state = await repo.getAllFolders();
  }

  Future<void> addFolder(String name, {String? color}) async {
    final repo = ref.read(folderRepositoryProvider);
    final folder = Folder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      color: color,
      createdAt: DateTime.now(),
    );
    await repo.addFolder(folder);
    await _loadFolders();
  }

  Future<void> renameFolder(String id, String newName) async {
    final repo = ref.read(folderRepositoryProvider);
    final folder = await repo.getFolderById(id);
    if (folder == null) return;
    await repo.updateFolder(folder.copyWith(name: newName));
    await _loadFolders();
  }

  Future<void> deleteFolder(String id) async {
    final repo = ref.read(folderRepositoryProvider);
    await repo.deleteFolder(id);
    await _loadFolders();
  }
}

final folderProvider = NotifierProvider<FolderNotifier, List<Folder>>(
  FolderNotifier.new,
);
