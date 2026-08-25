import 'package:mindspace/features/folders/domain/entities/folder.dart';

abstract class FolderRepository {
  Future<List<Folder>> getAllFolders();
  Future<Folder?> getFolderById(String id);
  Future<Folder> addFolder(Folder folder);
  Future<void> updateFolder(Folder folder);
  Future<void> deleteFolder(String id);
}
